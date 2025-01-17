{{ config (
    alias = 'job_credits_log'
) }}

{% set kp3r_token = "0x1ceb5cb57c4d4e2b2433641b95dd330a33185a44" %}
WITH work_evt AS (

    SELECT
        evt_block_time AS `timestamp`,
        evt_tx_hash AS tx_hash,
        evt_index,
        'KeeperWork' AS event,
        contract_address AS keep3r,
        _job AS job,
        _keeper AS keeper,
        _credit AS token,
        cast(_amount as FLOAT64) / 1e18 AS amount
    FROM
        (
            SELECT
                evt_block_time,
                evt_tx_hash,
                evt_index,
                contract_address,
                _job,
                _keeper,
                _credit,
                _amount
            FROM
                {{ source(
                    'keep3r_network_ethereum',
                    'Keep3r_evt_KeeperWork'
                ) }}
            UNION ALL
            SELECT
                evt_block_time,
                evt_tx_hash,
                evt_index,
                contract_address,
                _job,
                _keeper,
                _credit,
                _payment
            FROM
                {{ source(
                    'keep3r_network_ethereum',
                    'Keep3r_v2_evt_KeeperWork'
                ) }}
        ) keep3rWork
    WHERE
        _credit = LOWER('{{KP3R_token}}')
),
reward_evt AS (
    SELECT
        CASE
            WHEN LENGTH(_rewardedAt) = 10 THEN _rewardedAt :: INT :: TIMESTAMP
            ELSE _rewardedAt
        END AS `timestamp`,
        evt_tx_hash AS tx_hash,
        evt_index,
        'CreditsReward' AS event,
        contract_address AS keep3r,
        _job AS job,
        NULL AS keeper,
        '{{KP3R_token}}' AS token,
        CAST(_currentCredits AS FLOAT64) / 1e18 AS amount,
        CAST(_periodCredits AS FLOAT64) / 1e18 AS period_credits
    FROM
        (
            SELECT
                _rewardedAt,
                evt_tx_hash,
                evt_index,
                contract_address,
                _job,
                _currentCredits,
                _periodCredits
            FROM
                {{ source(
                    'keep3r_network_ethereum',
                    'Keep3r_evt_LiquidityCreditsReward'
                ) }}
            UNION ALL
            SELECT
                _rewardedAt,
                evt_tx_hash,
                evt_index,
                contract_address,
                _job,
                _currentCredits,
                _periodCredits
            FROM
                {{ source(
                    'keep3r_network_ethereum',
                    'Keep3r_v2_evt_LiquidityCreditsReward'
                ) }}
        ) rewards
)
SELECT
    `timestamp`,
    tx_hash,
    evt_index,
    event,
    keep3r,
    job,
    keeper,
    token,
    amount,
    NULL AS period_credits
FROM
    work_evt
UNION ALL
SELECT
    `timestamp`,
    tx_hash,
    evt_index,
    event,
    keep3r,
    job,
    keeper,
    token,
    amount,
    period_credits
FROM
    reward_evt
UNION ALL
SELECT
    `timestamp`,
    tx_hash,
    evt_index,
    event,
    keep3r,
    job,
    NULL AS keeper,
    '{{KP3R_token}}' AS token,
    NULL AS amount,
    NULL AS period_credits
FROM
    {{ ref('keep3r_network_ethereum_view_job_migrations') }}