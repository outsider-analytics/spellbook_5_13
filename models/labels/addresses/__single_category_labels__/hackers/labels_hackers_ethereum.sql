{{ config(alias='hackers_ethereum',
        post_hook='{{ expose_spells(\'["ethereum"]\',
                                    "sector",
                                    "labels",
                                    \'["ilemi","soispoke"]\') }}') }}

SELECT
    blockchain,
    address,
    name,
    category,
    contributor,
    source,
    created_at,
    updated_at,
    model_name,
    label_type
FROM (
    VALUES
    ('ethereum', '0xb3764761e297d6f121e79c32a65829cd1ddb4d32', 'Multisig Exploit Hacker', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x1342a001544b8b7ae4a5d374e33114c66d78bd5f', 'Gatecoin Hacker 2', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xd4914762f9bd566bd0882b71af5439c0476d2ff6', 'Gatecoin Hacker 1', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x04786aada9deea2150deab7b3b8911c309f5ed90', 'Gatecoin Hacker 4', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x86766247ba3405c5f15f06b895294200809e9cfb', 'CashioApp Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x905315602ed9a854e325f692ff82f58799beab57', 'Alpha Homora V2 Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x70747df6ac244979a2ae9ca1e1a82899d02bbea4', 'Cream Finance Flash Loan Exploiter 3', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x26446c1658b036a6fa3efb805f8fc538451d3fc2', 'ZBExchange Hacker 2', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x6ca33486eed915816560630b883a047c4e2b92df', 'Fake: Metadium Presale', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x71e9b2010cec7ff0017e3cac4e7e598223abf040', 'ChainPort Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x886358f9296de461d12e791bc9ef6f5a03410c64', 'Wault Finance Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xf224ab004461540778a914ea397c589b677e27bb', 'Harvest.Finance: Hacker 1', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xc61429117038a1f13881dd7410b80771f28e06ec', 'Uranium Finance Hacker', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xeb31973e0febf3e3d7058234a5ebbae1ab4b8c23', 'Kucoin Hacker', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x8e0d334a77614a7ce089c9246e9b1d7c7172ef02', 'Impossible Finance Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x5578840aae68682a9779623fa9e8714802b59946', 'Liquid Exchange Hacker 1', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x1d5a56402425c1099497c1ad715a6b56aaccb72b', 'Punk Protocol Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x2708cace7b42302af26f1ab896111d87faeff92f', 'DAOMaker Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x39fb0dcd13945b835d47410ae0de7181d3edf270', 'Bitmart Hacker', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xc8a65fadf0e0ddaf421f28feab69bf6e2e589963', 'PolyNetwork Exploiter 1', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xa2ce300cc17601fc660bac4eeb79bdd9ae61a0e5', 'Float Protocol Fuse Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x6e1218c55f1acb588fc5e55b721f1183d7d29d3d', 'ATO Stolen Funds', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x8f6a86f3ab015f4d03ddb13abb02710e6d7ab31b', 'MonoX Finance Exploiter 2', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x562331d30b14310870e29ead7a506c897e1d1657', 'SaturnbeamFi Rug Pull', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x921760e71fb58dcc8de902ce81453e9e3d7fe253', 'Cream Finance Flash Loan Exploiter 2', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x6e6dab47fed8cc3dd141959dd057f73d12146ba4', 'Vesper Finance VUSD Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x967bb571f0fc9ee79c892abf9f99233aa1737e31', 'bZx PrivKey Exploiter 3', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x894d11b8345712107da7baff191b474c27133289', 'Malicious Actor (Exploit Abuser) 2', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x5c1fe6f340dd36b5daf88c2cf390bf715d2af139', 'ChainPort Exploiter 3', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xa87fb85a93ca072cd4e5f0d4f178bc831df8a00b', 'PolyNetwork Exploiter 2', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x07e02088d68229300ae503395c6536f09179dc3e', 'xToken Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xa0d34572fb3be1bca9f36b5d41e86c135e580553', 'BadgerDAO Exploit Funder', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xcb36b1ee0af68dce5578a487ff2da81282512233', 'Rari Capital Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x56eb4a5f64fa21e13548b95109f42fa08a644628', 'AFKSystem', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x6b0b61323f6d77ef8a1a35d11fa877631d8f67bb', 'Brinc Finance Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x9007a0421145b06a0345d55a8c0f0327f62a2224', 'Cryptopia Hacker 3', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x26a76f4fe7a21160274d060acb209f515f35429c', '0xhabitat.eth Multisig Drainer', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x8efab89b497b887cdaa2fb08ff71e4b3827774b2', 'Visor Finance Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x44183fd1a79704f79e0986c6380dd9bfbbc7e6d2', 'KyberSwap Attacker 4', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x118203b0f2a3ef9e749d871c8fef5e5e55ef5c91', 'DEGO and Cocos Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x57a72ce4fd69ebedefc1a938b690fbf11a7dff80', 'KyberSwap Attacker 1', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x14ec0cd2acee4ce37260b925f74648127a889a28', 'Yearn (yDai) Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xf9e3d08196f76f5078882d98941b71c0884bea52', 'Popsicle Swap Hacker', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x5676e585bf16387bc159fd4f82416434cda5f1a3', 'NowSwap Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xa09871aeadf4994ca12f5c0b6056bbd1d343c029', 'Upbit Hacker 1', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x74487eed1e67f4787e8c0570e8d5d168a05254d4', 'bZx PrivKey Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xfd947851baa8f701871a8bb57cb82cdd64325aa8', 'Furucombo Hacker 2', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x9bc22f7e0234029eaf2c570588d829f07123fdd6', 'KyberSwap Attacker 5', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x4bb7d80282f5e0616705d7f832acfc59f89f7091', 'Bitmart Hacker 2', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xfd6f294f3c9e117dde30495770ba9b073c33b065', 'KyberSwap Attacker 2', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x2c6900b24221de2b4a45c8c89482fff96ffb7e55', 'AscendEX Hacker', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xb1302743acf31f567e9020810523f5030942e211', 'AnubisDAO Liquidity Rug 3', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x5ebc7d1ff1687a75f76c3edfabcde89d1c09cd5f', 'FinNexus Hacker', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xa0c7bd318d69424603cbf91e9969870f21b8ab4c', 'Audius Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x07ba7e8947f8fb4d33f3c7e25c2cb35b858f02eb', 'Siren Protocol Exploiter 1', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x71b1ee098dbe801ce7d42a4bdb472ed164f1c21a', 'Bent Finance Exploiter 3', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x0ae1554860e51844b61ae20823ef1268c3949f7c', 'AnySwap v3 Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xf4a2eff88a408ff4c4550148151c33c93442619e', 'Plus Token Ponzi 1', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x165402279f2c081c54b00f0e08812f3fd4560a05', 'LCX Hacker', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xeeee458c3a5eaafcfd68681d405fb55ef80595ba', 'Vee Finance Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x48ad05a3b73c9e7fac5918857687d6a11d2c73b1', 'Vulcan Forged Hacker', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xba5ed1488be60ba2facc6b66c6d6f0befba22ebe', 'Indexed Finance Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xf834efe5b959e52e3b78cb28c4bc501b52ce41da', 'Siren Protocol Exploiter 3', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x99da8fb52f74b7a3e38d9c75c634f6386f1649c7', 'Siren Protocol Exploiter 4', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xd23cfffa066f81c7640e3f0dc8bb2958f7686d1f', 'Bent Finance Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xfac4088bba1fa090fd3f1f52fd691a45c30ac053', 'Siren Protocol Exploiter 2', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x24354d31bc9d90f62fe5f2454709c32049cf866b', 'Cream Finance Flash Loan Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x3ddd8b6d092df917473680d6c41f80f708c45395', 'Miso Front End Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xe29a07002c7be4299b51a2892799cc4a372994dd', 'Force Vault Hacker 3', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x9d9c3695c54601929cd72d34a52935268eb9b00b', 'Force Vault Hacker 2', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x9e966a54082427d7ac56aeaee4baae7d11a6e468', 'Bent Finance Exploiter 2', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x67c67b5a3c4009cf849f86be37e79db3923f1055', 'ZBExchange Hacker 1', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xce1f4b4f17224ec6df16eeb1e3e5321c54ff6ede', 'Cream Finance Flashloan Attacker', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x42960c7f91e7aca98f374296df900cb4d6b09601', 'Etherwrapped Rug Pull', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x9fc53c75046900d1f58209f50f534852ae9f912a', 'AnubisDAO Liquidity Rug 2', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xc433d50dd0614c81ee314289ec82aa63710d25e8', 'Bondly Finance Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xa6964e26b6e49510934164ceab2dd73fd397509f', 'Fake_Phishing5041', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xa9bf70a420d364e923c74448d9d817d3f2a77822', 'Lendf.Me Hacker 1', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x4b713980d60b4994e0aa298a66805ec0d35ebc5a', 'THORChain Exploiter 1', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xafad9352eb6bcd085dd68268d353d0ed2571af89', 'bZx PrivKey Exploiter 5', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xa8189407a37001260975b9da61a81c3bd9f55908', 'SashimiSwap Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xecbe385f78041895c311070f344b55bfaa953258', 'MonoX Finance Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xef9427bf15783fb8e6885f9b5f5da1fba66ef931', 'DAOMaker Exploiter 2', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xf80f6fa4ccb6550c9dc58d58d51fb0928f9b323c', 'BELLE Honeypot Rug Pull', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xa3f447feb0b2bddc50a44ccd6f412a5f98619264', 'VesperFi Rari Fuse Pool Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x731821d13414487ea46f1b485cfb267019917689', 'Pancake Hunny Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x0acc0e5faa09cb1976237c3a9af3d3d4b2f35fa5', 'bZx PrivKey Exploiter 2', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xefb33ccafc98d5fdb27a6f5ff17350ca76bf3b53', 'Liquid Exchange Hacker 2', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xe47e8cd58c8e95f765e642d7dcb898f622cefa83', 'Arthur0x Wallet Hacker', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xe3cd90be37a79d9da86b5e14e2f6042cd0e53b66', 'Vulcan Forged Hacker 2', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x11112f684cb88d43ca0e132e585e882606063fbe', 'Malicious Actor (Exploit Abuser)', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x9c4c63a896f815acf14f73891a443fb84d0b54ef', 'MetaDAO Rug', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xa7f72bf63edeca25636f0b13ec5135296ca2ebb2', 'DragonEx Hacker', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xaa923cd02364bb8a4c3d6f894178d2e12231655c', 'Cryptopia Hacker 2', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xb624e2b10b84a41687caec94bdd484e48d76b212', 'Furucombo Hacker', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xc062dceed93087c9112ff7b02d53e928e49cec09', 'Gatecoin Hacker 3', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0xc8b759860149542a98a3eb57c14aadf59d6d89b9', 'Cryptopia Hacker 1', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x844f03375f7da2292da550aebfd52dff2cc6ad75', 'RUNE Token Exploiter', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x09923e35f19687a524bbca7d42b92b6748534f25', 'Nexus Mutual Hacker 1', 'hackers', 'ilemi', 'static', timestamp('2022-08-28'), now(), 'hackers_ethereum', 'identifier'),
    ('ethereum', '0x59ABf3837Fa962d6853b4Cc0a19513AA031fd32b', 'FTX Funds Drainer', 'hackers', 'augustog', 'static', timestamp('2022-11-15'), now(), 'hackers_ethereum', 'identifier')
)
