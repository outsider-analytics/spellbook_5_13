{{
    config(
        alias='trader_age',
        post_hook='{{ expose_spells(\'["ethereum", "fantom", "arbitrum", "avalanche_c", "gnosis", "bnb", "optimism", "polygon"]\',
                                    "sector",
                                    "labels",
                                    \'["gentrexha", "Henrystats"]\') }}'
    )
}}

with trader_age as (
    select
        blockchain,
        datediff(max(block_date), min(block_date)) as trader_age,
        taker as address
    from (
        select
            blockchain,
            taker,
            block_date
        from {{ ref('dex_aggregator_trades') }}
        union all
        select
            blockchain,
            taker,
            block_date
        from {{ ref('dex_trades') }}
    )
    group by taker, blockchain
)

select
    blockchain,
    address,
    case
        when trader_age > 1825 then '5 years old DEX trader'
        when trader_age > 1460 then '4 years old DEX trader'
        when trader_age > 1095 then '3 years old DEX trader'
        when trader_age > 730 then '2 years old DEX trader'
        when trader_age > 365 then '1 year old DEX trader'
        when trader_age > 91 then '3 months old DEX trader'
        when trader_age > 30 then '1 month old DEX trader'
        when trader_age > 7 then '1 week old DEX trader'
        else 'less than 1 week old DEX trader'
    end as name,
    'dex' as category,
    'gentrexha' as contributor,
    'query' as source,
    timestamp('2022-12-15') as created_at,
    now() as updated_at,
    'trader_age' as model_name,
    'usage' as label_type
from trader_age;
