{{ config(
    alias = 'redeem'
) }}

SELECT
r.evt_block_number AS block_number,
r.evt_block_time AS block_time,
r.evt_tx_hash AS tx_hash,
r.evt_index AS `index`,
CAST(r.contract_address AS STRING) AS contract_address,
r.redeemer,
i.symbol,
i.underlying_symbol,
i.underlying_token_address AS underlying_address,
CAST(r.redeemAmount AS FLOAT64) / power(10,i.underlying_decimals) AS redeem_amount,
CAST(r.redeemAmount AS FLOAT64) / power(10,i.underlying_decimals)*p.price AS redeem_usd
FROM {{ source('ironbank_ethereum', 'CErc20Delegator_evt_Redeem') }} r
LEFT JOIN {{ ref('ironbank_ethereum_itokens') }} i ON CAST(r.contract_address AS STRING) = i.contract_address
LEFT JOIN {{ source('prices', 'usd') }} p ON p.minute = TIMESTAMP_TRUNC(r.evt_block_time, minute) AND CAST(p.contract_address AS STRING) = i.underlying_token_address AND p.blockchain = 'ethereum'