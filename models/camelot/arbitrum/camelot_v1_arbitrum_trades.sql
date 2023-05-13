{{ config(
  schema = 'camelot_v1_arbitrum',
    alias = 'trades',
    partition_by = ['block_date'],
    materialized = 'incremental',
    file_format = 'delta',
    incremental_strategy = 'merge',
    unique_key = ['block_date', 'blockchain', 'project', 'version', 'tx_hash', 'evt_index', 'trace_address'])
}}


{% set project_start_date = '2022-11-03' %}
{% set blockchain = 'arbitrum' %}

WITH dexs AS (
    SELECT
        swap.evt_block_time AS block_time,
        swap.`to` AS taker,
        swap.sender AS maker,
        CASE
            WHEN swap.amount0out = 0 THEN swap.amount1out
            ELSE swap.amount0out
        END AS token_bought_amount_raw,
        CASE
            WHEN swap.amount0in = 0 THEN swap.amount1in
            ELSE swap.amount0in
        END AS token_sold_amount_raw,
        CAST(NULL AS double) AS amount_usd,
        CASE
            WHEN swap.amount0out = 0 THEN pairs.token1
            ELSE pairs.token0
        END AS token_bought_address,
        CASE
            WHEN swap.amount0in = 0 THEN pairs.token1
            ELSE pairs.token0
        END AS token_sold_address,
        swap.contract_address AS project_contract_address,
        swap.evt_tx_hash AS tx_hash,
        '' AS trace_address,
        swap.evt_index
    FROM {{ source('camelot_arbitrum', 'CamelotPair_evt_Swap') }} AS swap
    INNER JOIN {{ source('camelot_arbitrum', 'CamelotFactory_evt_PairCreated') }} AS pairs
        ON swap.contract_address = pairs.pair
    {% if not is_incremental() %}
  WHERE swap.evt_block_time >= '{{ project_start_date }}'
  {% endif %}
    {% if is_incremental() %}
        WHERE swap.evt_block_time >= DATE_TRUNC('DAY', NOW() - interval '1 WEEK')
    {% endif %}
)

SELECT
    '{{ blockchain }}' AS blockchain,
    'camelot' AS project,
    '1' AS version,
    TRY_CAST(DATE_TRUNC('DAY', dexs.block_time) AS date) AS block_date,
    dexs.block_time,
    erc20a.symbol AS token_bought_symbol,
    erc20b.symbol AS token_sold_symbol,
    CASE
        WHEN LOWER(erc20a.symbol) > LOWER(erc20b.symbol) THEN CONCAT(erc20b.symbol, '-', erc20a.symbol)
        ELSE CONCAT(erc20a.symbol, '-', erc20b.symbol)
    END AS token_pair,
    dexs.token_bought_amount_raw / POWER(10, erc20a.decimals) AS token_bought_amount,
    dexs.token_sold_amount_raw / POWER(10, erc20b.decimals) AS token_sold_amount,
    CAST(dexs.token_bought_amount_raw AS decimal(38, 0)) AS token_bought_amount_raw,
    CAST(dexs.token_sold_amount_raw AS decimal(38, 0)) AS token_sold_amount_raw,
    COALESCE(
        dexs.amount_usd,
        (dexs.token_bought_amount_raw / POWER(10, p_bought.decimals)) * p_bought.price,
        (dexs.token_sold_amount_raw / POWER(10, p_sold.decimals)) * p_sold.price
    ) AS amount_usd,
    dexs.token_bought_address,
    dexs.token_sold_address,
    COALESCE(dexs.taker, tx.from) AS taker,
    dexs.maker,
    dexs.project_contract_address,
    dexs.tx_hash,
    tx.from AS tx_from,
    tx.to AS tx_to,
    dexs.trace_address,
    dexs.evt_index
FROM dexs
INNER JOIN {{ source('arbitrum', 'transactions') }} AS tx
    ON
        tx.hash = dexs.tx_hash
        {% if not is_incremental() %}
    AND tx.block_time >= '{{ project_start_date }}'
    {% endif %}
        {% if is_incremental() %}
            AND tx.block_time >= DATE_TRUNC('DAY', NOW() - interval '1 WEEK')
        {% endif %}
LEFT JOIN {{ ref('tokens_erc20') }} AS erc20a
    ON
        erc20a.contract_address = dexs.token_bought_address
        AND erc20a.blockchain = '{{ blockchain }}'
LEFT JOIN {{ ref('tokens_erc20') }} AS erc20b
    ON
        erc20b.contract_address = dexs.token_sold_address
        AND erc20b.blockchain = '{{ blockchain }}'
LEFT JOIN {{ source('prices', 'usd') }} AS p_bought
    ON
        p_bought.minute = DATE_TRUNC('minute', dexs.block_time)
        AND p_bought.contract_address = dexs.token_bought_address
        AND p_bought.blockchain = '{{ blockchain }}'
        {% if not is_incremental() %}
    AND p_bought.minute >= '{{ project_start_date }}'
    {% endif %}
        {% if is_incremental() %}
            AND p_bought.minute >= DATE_TRUNC('DAY', NOW() - interval '1 WEEK')
        {% endif %}
LEFT JOIN {{ source('prices', 'usd') }} AS p_sold
    ON
        p_sold.minute = DATE_TRUNC('minute', dexs.block_time)
        AND p_sold.contract_address = dexs.token_sold_address
        AND p_sold.blockchain = '{{ blockchain }}'
        {% if not is_incremental() %}
    AND p_sold.minute >= '{{ project_start_date }}'
    {% endif %}
        {% if is_incremental() %}
            AND p_sold.minute >= DATE_TRUNC('DAY', NOW() - interval '1 WEEK')
        {% endif %}
;
