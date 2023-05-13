{{ config(
    schema = 'tigris_v2_polygon',
    alias = 'positions_leverage'
    )
 }}

WITH

leverage AS (
    SELECT
        evt_block_time,
        position_id,
        leverage
    FROM
        {{ ref('tigris_v2_polygon_events_open_position') }}

    UNION ALL

    SELECT
        evt_block_time,
        position_id,
        leverage
    FROM
        {{ ref('tigris_v2_polygon_events_modify_margin') }}

    UNION ALL

    SELECT
        evt_block_time,
        position_id,
        leverage
    FROM
        {{ ref('tigris_v2_polygon_events_limit_order') }}

)

SELECT * FROM leverage;
