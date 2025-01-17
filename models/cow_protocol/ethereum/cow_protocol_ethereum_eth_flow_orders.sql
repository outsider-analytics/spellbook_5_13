{{  config(
        alias='eth_flow_orders',
        materialized = 'view',
        partition_by = {"field": "block_date"},
        unique_key = ['tx_hash', 'order_uid'],
        on_schema_change='sync_all_columns',
                incremental_strategy='merge'
    )
}}

-- PoC Query: https://dune.com/queries/1762226
with
eth_flow_orders as (
    select
        sender,
        cast(TIMESTAMP_TRUNC(evt_block_time, day) as date) as block_date,
        evt_block_time as block_time,
        evt_block_number as block_number,
        evt_tx_hash as tx_hash,
        case
            when event.contract_address = '0x40a50cf069e992aa4536211b23f286ef88752187'
                then 'prod'
            when event.contract_address = '0xd02de8da0b71e1b59489794f423fabba2adc4d93'
                then 'barn'
        end as environment,
        -- This validity is always infinite. Instead we unpack this from the data field.
        -- timestamp_seconds(JSON_EXTRACT_SCALAR(event.order, '$.validTo')) as valid_to,
        timestamp_seconds(conv(substring(data, 19, 8), 16, 10)) as valid_to,
        conv(substring(data, 3, 16), 16, 10) as quote_id,
        -- These are unpacked so to hopefully make the join on trade events more efficient.
        JSON_EXTRACT_SCALAR(event.order, '$.sellAmount') as sell_amount,
        JSON_EXTRACT_SCALAR(event.order, '$.feeAmount') as fee,
        -- Additional potentially relevant fields (for unfilled orders)
        JSON_EXTRACT_SCALAR(event.order, '$.buyAmount') as buy_amount,
        JSON_EXTRACT_SCALAR(event.order, '$.buyToken') as buy_token,
        JSON_EXTRACT_SCALAR(event.order, '$.receiver') as receiver,
        JSON_EXTRACT_SCALAR(event.order, '$.appData') as app_hash,
        -- OrderHash returned by createOrder with excluded fix values (owner = contract_address, validTo = max u32)
        -- https://github.com/cowprotocol/ethflowcontract/blob/9c74c8ba36ff9ff3e255172b02454f831c066865/src/CoWSwapEthFlow.sol#L81-L84
        concat(output_orderHash, substring(event.contract_address, 3, 40), 'ffffffff') as order_uid
    from {{ source('cow_protocol_ethereum', 'CoWSwapEthFlow_evt_OrderPlacement') }} event
    inner join {{ source('cow_protocol_ethereum', 'CoWSwapEthFlow_call_createOrder') }} call
        on call_block_number = evt_block_number
        and call_tx_hash = evt_tx_hash
        and call_success = true
    {% if is_incremental() %}
    WHERE evt_block_time >= date_trunc("day", CURRENT_TIMESTAMP() - interval '1 week')
    AND call_block_time >= date_trunc("day", CURRENT_TIMESTAMP() - interval '1 week')
    {% endif %}
)

select * from eth_flow_orders