{{ config(
        alias ='mints'
        )
}}
 
SELECT blockchain,
project,
version,
block_time,
token_id,
CAST(NULL AS STRING) as collection,
amount_usd,
token_standard,
trade_type,
number_of_items,
CAST(NULL AS STRING) as trade_category,
evt_type,
seller,
buyer,
amount_original,
amount_raw,
currency_symbol,
currency_contract,
CAST(NULL AS STRING) as nft_contract_address,
project_contract_address,
CAST(NULL AS STRING) as aggregator_name,
CAST(NULL AS STRING) as aggregator_address,
block_number,
tx_hash,
CAST(NULL AS STRING) as tx_from,
CAST(NULL AS STRING) as tx_to,
unique_trade_id
FROM {{ ref('magiceden_solana_mints') }}