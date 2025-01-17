{{ config(alias='app_data'
)}}

-- Find the PoC Query here: https://dune.com/queries/1751965
with
partially_unpacked_app_content as (
    select
        distinct app_hash,
        content.appCode as app_code,
        content.environment,
        content.metadata.orderClass.orderClass as order_class,
        content.metadata.quote,
        content.metadata.referrer
    from {{ source('cowswap', 'raw_app_data') }}
),

unpacked_referrer_app_data as (
    select
        app_hash,
        app_code,
        environment,
        order_class,
        quote,
        -- different app data versions put referrer in two possible places.
        lower(coalesce(referrer.address, referrer.referrer)) as referrer
    from partially_unpacked_app_content
),

results as (
    select
        app_hash,
        app_code,
        environment,
        order_class,
        referrer,
        cast(quote.slippageBips as integer) slippage_bips
        -- There is only one App Data using buyAmount/sellAmount fields.
        -- cast(quote.sellAmount as FLOAT64) sell_amount,
        -- cast(quote.buyAmount as FLOAT64) buy_amount
    from unpacked_referrer_app_data
)

select * from results