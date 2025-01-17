{{ config(
    alias = 'fees',
    partition_by = {"field": "block_date"},
    materialized = 'view',
            unique_key = ['tx_hash','block_number']
    )
}}

SELECT 
     'optimism' as blockchain,
     TIMESTAMP_TRUNC(block_time, day) AS block_date,
     block_number,
     block_time,
     txns.hash AS tx_hash,
     txns.from AS tx_sender, 
     txns.to AS tx_receiver,
     'ETH' as native_token_symbol,
     value/1e18 AS tx_amount_native,
     value/1e18 * p.price AS tx_amount_usd,
     (l1_fee + (txns.gas_used * txns.gas_price))/1e18 as tx_fee_native, 
     (l1_fee + (txns.gas_used * txns.gas_price))/1e18 * p.price AS tx_fee_usd,
     cast(NULL as FLOAT64) AS burned_native, -- Not applicable for L2s
     cast(NULL as FLOAT64) AS burned_usd, -- Not applicable for L2s
     cast(NULL as string) as validator, -- Not applicable for L2s
     txns.gas_price/1e9 as gas_price_gwei,
     txns.gas_price/1e18 * p.price as gas_price_usd,
     txns.gas_used as gas_used,
     txns.gas_limit as gas_limit,
     txns.gas_used / txns.gas_limit * 100 as gas_usage_percent,
     l1_gas_price/1e9 as l1_gas_price_gwei,
     l1_gas_price/1e18 * p.price as l1_gas_price_usd,
     l1_gas_used,
     l1_fee_scalar,
     (l1_gas_price * txns.gas_used)/1e18 as tx_fee_equivalent_on_l1_native,
     (l1_gas_price * txns.gas_used)/1e18 * p.price as tx_fee_equivalent_on_l1_usd,
     (length( decode(TO_BASE64(FROM_HEX(substring(data,3))), 'US-ASCII') ) - length(replace(decode(TO_BASE64(FROM_HEX(substring(data,3))), 'US-ASCII') , chr(0), ''))) as num_zero_bytes,
     (length( replace(decode(TO_BASE64(FROM_HEX(substring(data,3))), 'US-ASCII'), chr(0), '')) ) as num_nonzero_bytes,
     16 * (length( replace( decode(TO_BASE64(FROM_HEX(substring(data,3))), 'US-ASCII') , chr(0), ''))) --16 * nonzero bytes
     + 4 * ( length( decode(TO_BASE64(FROM_HEX(substring(data,3))), 'US-ASCII') ) - length(replace( decode(TO_BASE64(FROM_HEX(substring(data,3))), 'US-ASCII') , chr(0), '')) ) --4 * zero bytes
     as calldata_gas,
     type as transaction_type
FROM {{ source('optimism','transactions') }} txns
JOIN {{ source('optimism','blocks') }} blocks ON blocks.number = txns.block_number
{% if is_incremental() %}
AND block_time >= date_trunc("day", CURRENT_TIMESTAMP() - interval '2 days')
AND blocks.time >= date_trunc("day", CURRENT_TIMESTAMP() - interval '2 days')
{% endif %}
LEFT JOIN {{ source('prices','usd') }} p ON p.minute = TIMESTAMP_TRUNC(block_time, minute)
AND p.blockchain = 'optimism'
AND p.symbol = 'WETH'
{% if is_incremental() %}
AND p.minute >= date_trunc("day", CURRENT_TIMESTAMP() - interval '2 days')
WHERE block_time >= date_trunc("day", CURRENT_TIMESTAMP() - interval '2 days')
AND blocks.time >= date_trunc("day", CURRENT_TIMESTAMP() - interval '2 days')
AND p.minute >= date_trunc("day", CURRENT_TIMESTAMP() - interval '2 days')
{% endif %}