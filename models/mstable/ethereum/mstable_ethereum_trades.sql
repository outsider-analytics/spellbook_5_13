{{ config(
    alias = 'trades',
    partition_by = ['block_date'],
    materialized = 'incremental',
    file_format = 'delta',
    incremental_strategy = 'merge',
    unique_key = ['block_date', 'blockchain', 'project', 'version', 'tx_hash', 'evt_index', 'trace_address'],
    post_hook='{{ expose_spells(\'["ethereum"]\',
                                    "project",
                                    "mstable",
                                    \'["dbustos20"]\') }}'
    )
}}

{% set project_start_date = '2020-05-28' %}

WITH dexs AS (
    SELECT
        evt_block_time AS block_time,
        'mstable' AS project,
        'masset' AS version,
        swapper AS taker,
        cast(NULL AS string) AS maker,
        `outputAmount` AS token_bought_amount_raw,
        cast(NULL AS double) AS token_sold_amount_raw,
        CASE
            WHEN `output` = lower('0x0000000000000000000000000000000000000000')
                THEN
                    lower('0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2')
            ELSE `output`
        END AS token_bought_address,
        CASE
            WHEN `input` = lower('0x0000000000000000000000000000000000000000')
                THEN
                    lower('0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2')
            ELSE `input`
        END AS token_sold_address,
        contract_address AS project_contract_address,
        evt_tx_hash AS tx_hash,
        '' AS trace_address,
        cast(NULL AS double) AS amount_usd,
        evt_index
    FROM {{ source('mstable_ethereum', 'Masset_evt_Swapped') }}
    {% if is_incremental() %}
        WHERE evt_block_time >= date_trunc('day', now() - interval '1 week')
    {% endif %}

    UNION ALL

    SELECT
        evt_block_time AS block_time,
        'mstable' AS project,
        'feederpool' AS version,
        swapper AS taker,
        cast(NULL AS string) AS maker,
        `outputAmount` AS token_bought_amount_raw,
        cast(NULL AS double) AS token_sold_amount_raw,
        CASE
            WHEN `output` = lower('0x0000000000000000000000000000000000000000')
                THEN
                    lower('0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2')
            ELSE `output`
        END AS token_bought_address,
        CASE
            WHEN `input` = lower('0x0000000000000000000000000000000000000000')
                THEN
                    lower('0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2')
            ELSE `input`
        END AS token_sold_address,
        contract_address AS project_contract_address,
        evt_tx_hash AS tx_hash,
        '' AS trace_address,
        cast(NULL AS double) AS amount_usd,
        evt_index
    FROM {{ source('mstable_ethereum', 'FeederPool_evt_Swapped') }}
    {% if is_incremental() %}
        WHERE evt_block_time >= date_trunc('day', now() - interval '1 week')
    {% endif %}
)

SELECT
    'ethereum' AS blockchain,
    dexs.project,
    dexs.version,
    TRY_CAST(date_trunc('DAY', dexs.block_time) AS date) AS block_date,
    dexs.block_time,
    erc20a.symbol AS token_bought_symbol,
    erc20b.symbol AS token_sold_symbol,
    CASE
        WHEN lower(erc20a.symbol) > lower(erc20b.symbol) THEN concat(erc20b.symbol, '-', erc20a.symbol)
        ELSE concat(erc20a.symbol, '-', erc20b.symbol)
    END AS token_pair,
    dexs.token_bought_amount_raw / power(10, erc20a.decimals) AS token_bought_amount,
    dexs.token_sold_amount_raw / power(10, erc20b.decimals) AS token_sold_amount,
    CAST(dexs.token_bought_amount_raw AS decimal(38, 0)) AS token_bought_amount_raw,
    CAST(dexs.token_sold_amount_raw AS decimal(38, 0)) AS token_sold_amount_raw,
    coalesce(
        dexs.amount_usd,
        dexs.token_bought_amount_raw / power(10, p_bought.decimals) * p_bought.price,
        dexs.token_sold_amount_raw / power(10, p_sold.decimals) * p_sold.price
    ) AS amount_usd,
    dexs.token_bought_address,
    dexs.token_sold_address,
    coalesce(dexs.taker, tx.`from`) AS taker, -- subqueries rely on this COALESCE to avoid redundant joins with the transactions table
    dexs.maker,
    dexs.project_contract_address,
    dexs.tx_hash,
    tx.`from` AS tx_from,
    tx.`to` AS tx_to,
    dexs.trace_address,
    dexs.evt_index
FROM dexs
INNER JOIN {{ source('ethereum', 'transactions') }} AS tx
    ON
        dexs.tx_hash = tx.hash
        {% if not is_incremental() %}
    AND tx.block_time >= '{{ project_start_date }}'
    {% endif %}
        {% if is_incremental() %}
            AND tx.block_time >= date_trunc('day', now() - interval '1 week')
        {% endif %}
LEFT JOIN {{ ref('tokens_erc20') }} AS erc20a
    ON
        erc20a.contract_address = dexs.token_bought_address
        AND erc20a.blockchain = 'ethereum'
LEFT JOIN {{ ref('tokens_erc20') }} AS erc20b
    ON
        erc20b.contract_address = dexs.token_sold_address
        AND erc20b.blockchain = 'ethereum'
LEFT JOIN {{ source('prices', 'usd') }} AS p_bought
    ON
        p_bought.minute = date_trunc('minute', dexs.block_time)
        AND p_bought.contract_address = dexs.token_bought_address
        AND p_bought.blockchain = 'ethereum'
        {% if not is_incremental() %}
    AND p_bought.minute >= '{{ project_start_date }}'
    {% endif %}
        {% if is_incremental() %}
            AND p_bought.minute >= date_trunc('day', now() - interval '1 week')
        {% endif %}
LEFT JOIN {{ source('prices', 'usd') }} AS p_sold
    ON
        p_sold.minute = date_trunc('minute', dexs.block_time)
        AND p_sold.contract_address = dexs.token_sold_address
        AND p_sold.blockchain = 'ethereum'
        {% if not is_incremental() %}
    AND p_sold.minute >= '{{ project_start_date }}'
    {% endif %}
        {% if is_incremental() %}
            AND p_sold.minute >= date_trunc('day', now() - interval '1 week')
        {% endif %}
;
