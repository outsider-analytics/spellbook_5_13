{{ config(
      alias='stablecoins'
      , tags=['static']
      
  )
}}




SELECT
  LOWER(tbl.contract_address) as contract_address
  , et.symbol,et. decimals
  , tbl.name, tbl.currency_peg, tbl.reserve_type

FROM UNNEST(ARRAY<STRUCT<contract_address STRING,name STRING,currency_peg STRING,reserve_type STRING>> [STRUCT('0xda10009cbd5d07dd0cecc66161fc93d7c9000da1', 'Dai Stablecoin', 'USD', 'Crypto-Backed'),
STRUCT('0x94b008aa00579c1307b0ef2c499ad98a8ce58e58', 'Tether USD', 'USD', 'Fiat-Backed'),
STRUCT('0x7f5c764cbc14f9669b88837ca1490cca17c31607', 'USD Coin', 'USD', 'Fiat-Backed'),
STRUCT('0xc40f949f8a4e094d1b49a23ea9241d289b7b2819', 'LUSD Stablecoin', 'USD', 'Crypto-Backed'),
STRUCT('0xbfd291da8a403daaf7e5e9dc1ec0aceacd4848b9', 'dForce USD', 'USD', 'Crypto-Backed'),
STRUCT('0x2e3d870790dc77a83dd1d18184acc7439a53f475', 'FRAX', 'USD', 'Algorithmic'),
STRUCT('0xba28feb4b6a6b81e3f26f08b83a19e715c4294fd', 'UST (Wormhole)', 'USD', 'Algorithmic'),
STRUCT('0xfb21b70922b9f6e3c6274bcd6cb1aa8a0fe20b80', 'Terra USD', 'USD', 'Algorithmic'),
STRUCT('0x7113370218f31764c1b6353bdf6004d86ff6b9cc', 'Decentralized USD','USD','Algorithmic'),
STRUCT('0xcb59a0a753fdb7491d5f3d794316f1ade197b21e', 'TrueUSD','USD','Fiat-Backed'),
STRUCT('0xcb8fa9a76b8e203d8c3797bf438d8fb81ea3326a', 'Alchemix USD','USD','Algorithmic'),
STRUCT('0xb0b195aefa3650a6908f15cdac7d92f8a5791b0b', 'BOB','USD','Crypto-Backed'),
STRUCT('0xdfa46478f9e5ea86d57387849598dbfb2e964b02', 'Mai Stablecoin','USD','Crypto-Backed'),
STRUCT('0x7fb688ccf682d58f86d7e38e03f9d22e7705448b', 'Rai Reflex Index','None','Crypto-Backed'),
STRUCT('0x340fe1d898eccaad394e2ba0fc1f93d27c7b717a', 'Wrapped USDR','USD','Algorithmic'),
STRUCT('0x9c9e5fd8bbc25984b178fdce6117defa39d2db39', 'Binance-Peg BUSD Token','USD','Fiat-Backed'),
STRUCT('0xb153fb3d196a8eb25522705560ac152eeec57901', 'Magic Internet Money','USD','Crypto-Backed'),
STRUCT('0x8ae125e8653821e851f12a49f7765db9a9ce7384', 'Dola USD Stablecoin','USD','Crypto-Backed'),
STRUCT('0x73cb180bf0521828d8849bc8CF2B920918e23032', 'USD+', 'USD','Crypto-Backed'),
STRUCT('0x9485aca5bbbe1667ad97c7fe7c4531a624c8b1ed', 'agEUR', 'EUR', 'Crypto-Backed'),
STRUCT('0x79af5dd14e855823fa3e9ecacdf001d99647d043', 'Jarvis Synthetic Euro','EUR','Crypto-Backed'),
STRUCT('0x970d50d09f3a656b43e11b0d45241a84e3a6e011', 'DAI+', 'USD','Crypto-Backed'),
STRUCT('0x8c6f28f2f1a3c87f0f938b96d27520d9751ec8d9', 'Synth sUSD', 'USD', 'Crypto-Backed'),
STRUCT('0xfbc4198702e81ae77c06d58f81b629bdf36f0a71', 'Synth sEUR', 'EUR', 'Crypto-Backed'),
STRUCT('0xa3a538ea5d5838dc32dde15946ccd74bdd5652ff', 'Synth sINR', 'INR', 'Crypto-Backed'),
STRUCT('0x25d8039bb044dc227f741a9e381ca4ceae2e6ae8', 'USD Coin Hop Token', 'USD', 'Bridge-Backed'),
STRUCT('0x3666f603cc164936c1b87e207f36beba4ac5f18a', 'USD Coin Hop Token', 'USD', 'Bridge-Backed'),
STRUCT('0x2057c8ecb70afd7bee667d76b4cd373a325b1a20', 'Tether USD Hop Token', 'USD', 'Bridge-Backed'),
STRUCT('0x56900d66d74cb14e3c86895789901c9135c95b16', 'DAI Hop Token', 'USD', 'Bridge-Backed'),
STRUCT('0x67c10c397dd0ba417329543c1a40eb48aaa7cd00', 'Synapse USD', 'USD', 'Bridge-Backed')])




INNER JOIN {{ref('tokens_optimism_erc20')}} et 
  ON et.contract_address = tbl.contract_address
  AND et.is_counted_in_tvl = 1