{{ config(
        alias ='aggregators')
}}

SELECT 'avalanche_c' as blockchain, * FROM  {{ ref('nft_avalanche_c_aggregators') }}
UNION ALL
SELECT 'bnb' as blockchain, * FROM  {{ ref('nft_bnb_aggregators') }}
UNION ALL
SELECT 'ethereum' as blockchain, * FROM  {{ ref('nft_ethereum_aggregators') }}
UNION ALL
SELECT 'polygon' as blockchain, * FROM  {{ ref('nft_polygon_aggregators') }}
UNION ALL
SELECT 'optimism' as blockchain, * FROM  {{ ref('nft_optimism_aggregators') }}