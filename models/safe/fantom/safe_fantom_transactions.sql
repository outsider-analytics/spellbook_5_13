{{ 
    config(
        materialized='incremental',
        alias='transactions',
        partition_by = ['block_date'],
        unique_key = ['block_date', 'tx_hash', 'trace_address'], 
        file_format ='delta',
        incremental_strategy='merge',
        post_hook='{{ expose_spells(\'["fantom"]\',
                                    "project",
                                    "safe",
                                    \'["tschubotz"]\') }}'
    ) 
}}

select
    'fantom' as blockchain,
    try_cast(date_trunc('day', tr.block_time) as date) as block_date,
    tr.block_time,
    tr.block_number,
    tr.tx_hash,
    s.address,
    tr.to,
    tr.value,
    tr.gas,
    tr.gas_used,
    tr.tx_index,
    tr.sub_traces,
    tr.trace_address,
    tr.success,
    tr.error,
    tr.code,
    tr.input,
    tr.output,
    case
        when substring(tr.input, 0, 10) = '0x6a761202' then 'execTransaction'
        when substring(tr.input, 0, 10) = '0x468721a7' then 'execTransactionFromModule'
        when substring(tr.input, 0, 10) = '0x5229073f' then 'execTransactionFromModuleReturnData'
        else 'unknown'
    end as method
from {{ source('fantom', 'traces') }} as tr
inner join {{ ref('safe_fantom_safes') }} as s
    on s.address = tr.from
inner join {{ ref('safe_fantom_singletons') }} as ss
    on tr.to = ss.address
where
    substring(tr.input, 0, 10) in (
        '0x6a761202', -- execTransaction
        '0x468721a7', -- execTransactionFromModule
        '0x5229073f' -- execTransactionFromModuleReturnData
    )
    and tr.call_type = 'delegatecall'
    {% if not is_incremental() %}
    and tr.block_time > '2021-11-25' -- for initial query optimisation    
    {% endif %}
    {% if is_incremental() %}
        and tr.block_time > date_trunc('day', now() - interval '1 week')
    {% endif %}
