{{ config(
    alias ='events',
    partition_by = ['block_date'],
    materialized = 'incremental',
    file_format = 'delta',
    incremental_strategy = 'merge',
    unique_key = ['block_date', 'unique_trade_id'],
    post_hook='{{ expose_spells(\'["ethereum"]\',
                    "project",
                    "looksrare",
                    \'["hildobby"]\') }}')
}}

{% set nft_models = [
 ref('looksrare_v1_ethereum_events')
,ref('looksrare_v2_ethereum_events')
] %}

SELECT *
FROM (
    {% for nft_model in nft_models %}
        SELECT
            blockchain,
            project,
            version,
            date_trunc('day', block_time) AS block_date,
            block_time,
            token_id,
            collection,
            amount_usd,
            token_standard,
            trade_type,
            number_of_items,
            trade_category,
            evt_type,
            seller,
            buyer,
            amount_original,
            amount_raw,
            currency_symbol,
            currency_contract,
            nft_contract_address,
            project_contract_address,
            aggregator_name,
            aggregator_address,
            tx_hash,
            block_number,
            tx_from,
            tx_to,
            platform_fee_amount_raw,
            platform_fee_amount,
            platform_fee_amount_usd,
            platform_fee_percentage,
            royalty_fee_receive_address,
            royalty_fee_currency_symbol,
            royalty_fee_amount_raw,
            royalty_fee_amount,
            royalty_fee_amount_usd,
            royalty_fee_percentage,
            unique_trade_id
        FROM {{ nft_model }}
        {% if is_incremental() %}
            WHERE block_time >= date_trunc('day', now() - interval '1 week')
        {% endif %}
        {% if not loop.last %}
            UNION ALL
        {% endif %}
    {% endfor %}
)
