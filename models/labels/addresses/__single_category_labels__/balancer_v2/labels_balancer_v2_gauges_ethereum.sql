{{config(alias='balancer_v2_gauges_ethereum')}}

SELECT
    'ethereum' AS blockchain,
    gauge AS address,
    'eth:' || pools.name AS name,
    'balancer_v2_gauges' AS category,
    'balancerlabs' AS contributor,
    'query' AS source,
    TIMESTAMP('2022-01-13') AS created_at,
    CURRENT_TIMESTAMP() AS updated_at,
    'balancer_v2_gauges_ethereum' AS model_name,
    'identifier' AS label_type
FROM
    {{ source('balancer_ethereum', 'LiquidityGaugeFactory_evt_GaugeCreated') }} gauge
    LEFT JOIN {{ ref('labels_balancer_v2_pools_ethereum') }} pools ON pools.address = gauge.pool
UNION ALL
SELECT
    'ethereum' AS blockchain,
    gauge AS address,
    'eth:' || pools.name AS name,
    'balancer_v2_gauges' AS category,
    'balancerlabs' AS contributor,
    'query' AS source,
    TIMESTAMP('2022-01-13') AS created_at,
    CURRENT_TIMESTAMP() AS updated_at,
    'balancer_v2_gauges_ethereum' AS model_name,
    'identifier' AS label_type
FROM
    {{ source('balancer_ethereum', 'CappedLiquidityGaugeFactory_evt_GaugeCreated') }} evt
    INNER JOIN {{ source('balancer_ethereum', 'CappedLiquidityGaugeFactory_call_create') }} call ON call.call_tx_hash = evt.evt_tx_hash
    LEFT JOIN {{ ref('labels_balancer_v2_pools_ethereum') }} pools ON pools.address = call.pool