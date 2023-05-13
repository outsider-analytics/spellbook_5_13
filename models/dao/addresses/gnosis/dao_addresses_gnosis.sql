{{ config(alias='addresses_gnosis') }}

WITH

mapping AS (
    SELECT
        blockchain,
        dao_creator_tool,
        dao,
        dao_wallet_address,
        created_block_time,
        created_date
    FROM {{ ref('aragon_gnosis_dao_addresses') }}

    UNION ALL

    SELECT
        blockchain,
        dao_creator_tool,
        dao,
        dao_wallet_address,
        created_block_time,
        created_date
    FROM {{ ref('dao_addresses_gnosis_daohaus') }}

    UNION ALL

    SELECT
        blockchain,
        dao_creator_tool,
        dao,
        dao_wallet_address,
        created_block_time,
        created_date
    FROM {{ ref('dao_addresses_gnosis_colony') }}
)

SELECT * FROM mapping
