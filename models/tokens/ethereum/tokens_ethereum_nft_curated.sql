{{ config(
        alias='nft_curated',
        tags=['static']
        )
}}

SELECT
  contract_address, name, symbol
FROM
  {{ ref( 'tokens_ethereum_nft_curated_0_seed' ) }}