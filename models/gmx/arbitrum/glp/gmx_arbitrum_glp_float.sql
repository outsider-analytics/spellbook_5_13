{{ config(
        alias = 'glp_float',
        partition_by = {"field": "block_date"},
        materialized = 'view',
                        unique_key = ['block_date', 'minute']
        )
}}

{% set project_start_date = '2021-08-31 08:13' %}

WITH minute AS  -- This CTE generates a series of minute values
    (
    SELECT *
    FROM
        (
        {% if not is_incremental() %}
        SELECT explode(sequence(TIMESTAMP '{{project_start_date}}', CURRENT_TIMESTAMP, interval 1 minute)) AS minute -- 2021-08-31 08:13 is the timestamp of the first vault transaction
        {% endif %}
        {% if is_incremental() %}
        SELECT explode(sequence(date_trunc("day", CURRENT_TIMESTAMP() - interval '1 week'), CURRENT_TIMESTAMP, interval 1 minute)) AS minute
        {% endif %}
        )
    ),

/*
GLP tokens are minted and burned by the GLP Manager contract by invoking addLiquidity() and removeLiquidity()
The GLP Manager contract can be found here: https://arbiscan.io/address/0x321F653eED006AD1C29D174e17d96351BDe22649
*/

glp_balances AS -- This CTE returns the accuals of WETH tokens in the Fee GLP contract in a designated minute
    (    
    SELECT -- This subquery aggregates the mints and burns of GLP tokens over the minute series
        b.minute,
        b.glp_mint_burn_value,
        SUM(b.glp_mint_burn_value) OVER (ORDER BY b.minute ASC) AS glp_cum_balance
    FROM
        (
        SELECT  -- This subquery aggregates all the inbound tranfers of mints and burns of GLP tokens in a designated minute
            a.minute,
            SUM(a.mint_burn_value) AS glp_mint_burn_value
        FROM
            (
            SELECT  -- This subquery truncates the block time to a minute and selects all mints and burns of GLP tokens through the GLP Manager contract
                TIMESTAMP_TRUNC(evt_block_time, minute) AS minute,
                mintAmount/1e18 AS mint_burn_value
            FROM {{source('gmx_arbitrum', 'GlpManager_evt_AddLiquidity')}}
            {% if not is_incremental() %}
            WHERE evt_block_time >= '{{project_start_date}}'
            {% endif %}
            {% if is_incremental() %}
            WHERE evt_block_time >= date_trunc("day", CURRENT_TIMESTAMP() - interval '1 week')
            {% endif %}

            UNION ALL

            SELECT
                TIMESTAMP_TRUNC(evt_block_time, minute) AS minute,
                (-1 * glpAmount)/1e18 AS mint_burn_value
            FROM {{source('gmx_arbitrum', 'GlpManager_evt_RemoveLiquidity')}}
            {% if not is_incremental() %}
            WHERE evt_block_time >= '{{project_start_date}}'
            {% endif %}
            {% if is_incremental() %}
            WHERE evt_block_time >= date_trunc("day", CURRENT_TIMESTAMP() - interval '1 week')
            {% endif %}
            ) a
        GROUP BY a.minute
        ) b
    )

SELECT
    x.minute,
    SAFE_CAST(TIMESTAMP_TRUNC(x.minute, DAY) AS date) AS block_date,
    COALESCE(x.glp_mint_burn,0) AS glp_mint_burn, -- Removes null values
    COALESCE(x.glp_float,0) AS glp_float -- Removes null values
FROM
    (
    SELECT
        a.minute AS minute,
        b.glp_mint_burn_value AS glp_mint_burn,
        last(b.glp_cum_balance, true) OVER (ORDER BY a.minute ASC) AS glp_float -- extrapolation
    FROM minute a    
    LEFT JOIN
        (
        SELECT
            minute,
            glp_mint_burn_value,
            glp_cum_balance
        FROM glp_balances
        {% if not is_incremental() %}
        WHERE minute >= '{{project_start_date}}'
        {% endif %}
        {% if is_incremental() %}
        WHERE minute >= date_trunc("day", CURRENT_TIMESTAMP() - interval '1 week')
        {% endif %}
        ) b
        ON a.minute = b.minute
    ) x