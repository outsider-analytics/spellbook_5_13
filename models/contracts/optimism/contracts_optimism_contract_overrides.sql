{{ 
  config(
    alias='contract_overrides',
    unique_key='contract_address'
    ) 
}}

select 
  lower(contract_address) as contract_address
  ,cast(contract_project as STRING) AS contract_project
  ,contract_name
FROM UNNEST(ARRAY<STRUCT<contract_address STRING,contract_project STRING,contract_name STRING>> [STRUCT('0xc30141B657f4216252dc59Af2e7CdB9D8792e1B0', 'Socket', 'Socket Registry'),
STRUCT('0x81b30ff521D1fEB67EDE32db726D95714eb00637', 'Optimistic Explorer', 'OptimisticExplorerNFT'),
STRUCT('0x998EF16Ea4111094EB5eE72fC2c6f4e6E8647666', 'Quix', 'Seaport'),
STRUCT('0xEE36eaaD94d1Cc1d0eccaDb55C38bFfB6Be06C77', 'AttestationStation','AttestationStation'),
STRUCT('0x9dDA6Ef3D919c9bC8885D5560999A3640431e8e6', 'Metamask', 'Metamask Swaps'),
STRUCT('0x74A002D13f5F8AF7f9A971f006B9a46c9b31DaBD', 'Rabbithole', 'RabbitHoleExplorerNFT'),
STRUCT('0xcD487Bbd5F6f9AFD3CEa637A1803b6E8d71C958A', 'BitKeep', 'SwapRouter'),
STRUCT('0x15DdA60616Ffca20371ED1659dBB78E888f65556', 'RetroPGF Receiver', 'AssetReceiver'),
STRUCT('0x92D932aBBC7885999c4347880Eb069F854982eDD', 'OKX NFT', NULL),
STRUCT('0x86Bb63148d17d445Ed5398ef26Aa05Bf76dD5b59', 'Layer Zero', 'TheAptosBridge'),
STRUCT('0x00000000000076a84fef008cdabe6409d2fe638b', 'DelegateCash', 'delegationRegistry'),
STRUCT('0x82E0b8cDD80Af5930c4452c684E71c861148Ec8A', 'Metamask', 'Metamask BridgeRouter'),
STRUCT('0x81E792e5a9003CC1C8BF5569A00f34b65d75b017', 'Layer Zero', 'Relayer v2'),
STRUCT('0xA0Cc33Dd6f4819D473226257792AFe230EC3c67f', 'Layer Zero', 'LayerZero Oracle'),
STRUCT('0x80C67432656d59144cEFf962E8fAF8926599bCF8', 'Orbiter Finance', 'Bridge')])