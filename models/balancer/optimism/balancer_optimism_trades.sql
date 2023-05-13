{{ config(
    alias = 'trades',
    partition_by = ['block_date'],
    materialized = 'incremental',
    file_format = 'delta',
    incremental_strategy = 'merge',
    unique_key = ['block_date', 'blockchain', 'project', 'version', 'tx_hash', 'evt_index', 'trace_address'],
    post_hook='{{ expose_spells(\'["optimism"]\',
                                "project",
                                "balancer",
                                \'["bizzyvinci"]\') }}'
    )
}}

{% set project_start_date = '2022-05-23' %}

with v2 as (
    select
        '2' as version,
        tokenout as token_bought_address,
        amountout as token_bought_amount_raw,
        tokenin as token_sold_address,
        amountin as token_sold_amount_raw,
        pooladdress as project_contract_address,
        s.evt_block_time,
        s.evt_tx_hash,
        s.evt_index
    from {{ source('balancer_v2_optimism', 'Vault_evt_Swap') }} as s
    inner join {{ source('balancer_v2_optimism', 'Vault_evt_PoolRegistered') }} as p
        on s.poolid = p.poolid
    {% if not is_incremental() %}
        where s.evt_block_time >= '{{ project_start_date }}'
    {% endif %}
    {% if is_incremental() %}
        where s.evt_block_time >= date_trunc('day', now() - interval '1 week')
    {% endif %}
),

prices as (
    select * from {{ source('prices', 'usd') }}
    where
        blockchain = 'optimism'
        {% if not is_incremental() %}
        and minute >= '{{ project_start_date }}'
    {% endif %}
        {% if is_incremental() %}
            and minute >= date_trunc('day', now() - interval '1 week')
        {% endif %}
)


select
    'optimism' as blockchain,
    'balancer' as project,
    version,
    evt_block_time as block_time,
    date_trunc('day', evt_block_time) as block_date,
    erc20a.symbol as token_bought_symbol,
    erc20b.symbol as token_sold_symbol,
    case
        when lower(erc20a.symbol) > lower(erc20b.symbol) then concat(erc20b.symbol, '-', erc20a.symbol)
        else concat(erc20a.symbol, '-', erc20b.symbol)
    end as token_pair,
    token_bought_amount_raw / power(10, erc20a.decimals) as token_bought_amount,
    token_sold_amount_raw / power(10, erc20b.decimals) as token_sold_amount,
    CAST(token_bought_amount_raw as decimal(38, 0)) as token_bought_amount_raw,
    CAST(token_sold_amount_raw as decimal(38, 0)) as token_sold_amount_raw,
    coalesce(
        (token_bought_amount_raw / power(10, p_bought.decimals)) * p_bought.price,
        (token_sold_amount_raw / power(10, p_sold.decimals)) * p_sold.price
    ) as amount_usd,
    token_bought_address,
    token_sold_address,
    tx.from as taker,
    cast(null as varchar(5)) as maker,
    project_contract_address,
    evt_tx_hash as tx_hash,
    tx.from as tx_from,
    tx.to as tx_to,
    evt_index,
    '' as trace_address
from v2 as trades
inner join {{ source('optimism', 'transactions') }} as tx
    on
        trades.evt_tx_hash = tx.hash
        {% if not is_incremental() %}
    and tx.block_time >= '{{ project_start_date }}'
    {% endif %}
        {% if is_incremental() %}
            and tx.block_time >= date_trunc('day', now() - interval '1 week')
        {% endif %}
left join {{ ref('tokens_erc20') }} as erc20a
    on
        trades.token_bought_address = erc20a.contract_address
        and erc20a.blockchain = 'optimism'
left join {{ ref('tokens_erc20') }} as erc20b
    on
        trades.token_sold_address = erc20b.contract_address
        and erc20b.blockchain = 'optimism'
left join prices as p_bought
    on
        p_bought.minute = date_trunc('minute', trades.evt_block_time)
        and p_bought.contract_address = trades.token_bought_address
left join prices as p_sold
    on
        p_sold.minute = date_trunc('minute', trades.evt_block_time)
        and p_sold.contract_address = trades.token_sold_address
