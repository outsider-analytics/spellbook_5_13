{{ config(materialized = 'view', alias='test_view') }}

with
  erc1155_ids_batch AS (
    SELECT
      *,
      explode_id,
    evt_tx_hash || '-' || CAST(ROW_NUMBER() OVER (PARTITION BY evt_tx_hash, ids ORDER BY ids) AS STRING) AS unique_transfer_id
  FROM
    `blocktrekker`.`erc1155_ethereum`.`evt_transferbatch`,
    UNNEST(ids) AS explode_id
      limit 100
  ),

  erc1155_values_batch AS (
    SELECT
      *,
      explode_value,
      evt_tx_hash || '-' || cast(
        row_number() OVER (
          PARTITION BY evt_tx_hash,
          ids
          ORDER BY
            ids
        ) as string
      ) as unique_transfer_id
    FROM {{source('erc1155_ethereum', 'evt_transferbatch')}},
    UNNEST(values) AS explode_value
            limit 100
  ),

  erc1155_transfers_batch AS (
    SELECT
      DISTINCT erc1155_ids_batch.explode_id,
      erc1155_values_batch.explode_value,
      erc1155_ids_batch.evt_tx_hash,
      erc1155_ids_batch.to,
      erc1155_ids_batch.from,
      erc1155_ids_batch.contract_address,
      erc1155_ids_batch.evt_index,
      erc1155_ids_batch.evt_block_time
    FROM erc1155_ids_batch
      JOIN erc1155_values_batch ON erc1155_ids_batch.unique_transfer_id = erc1155_values_batch.unique_transfer_id
    limit 100
  ),

  sent_transfers as (
    select
      evt_tx_hash,
      evt_tx_hash || '-' || evt_index || '-' || `to` as unique_tx_id,
      `to` as wallet_address,
      contract_address as token_address,
      evt_block_time,
      id as tokenId,
      `value` as amount
    FROM {{source('erc1155_ethereum', 'evt_transfersingle')}} single
    UNION ALL
    select
      evt_tx_hash,
      evt_tx_hash || '-' || evt_index || '-' || `to` as unique_tx_id,
      `to` as wallet_address,
      contract_address as token_address,
      evt_block_time,
      explode_id as tokenId,
      explode_value as amount
    FROM erc1155_transfers_batch
          limit 100
  ),

  received_transfers as (
    select
      evt_tx_hash,
      evt_tx_hash || '-' || evt_index || '-' || `to` as unique_tx_id,
      `from` as wallet_address,
      contract_address as token_address,
      evt_block_time,
      id as tokenId,
      - value as amount
    FROM {{source('erc1155_ethereum', 'evt_transfersingle')}}
    UNION ALL
    select
      evt_tx_hash,
      evt_tx_hash || '-' || evt_index || '-' || `to` as unique_tx_id,
      `from` as wallet_address,
      contract_address as token_address,
      evt_block_time,
      explode_id as tokenId,
      - explode_value as amount
    FROM erc1155_transfers_batch
    limit 100
  )

select 'ethereum' as blockchain, wallet_address, token_address, evt_block_time, tokenId, amount, evt_tx_hash, unique_tx_id
from sent_transfers
union all
select 'ethereum' as blockchain, wallet_address, token_address, evt_block_time, tokenId, amount, evt_tx_hash, unique_tx_id
from received_transfers
limit 100