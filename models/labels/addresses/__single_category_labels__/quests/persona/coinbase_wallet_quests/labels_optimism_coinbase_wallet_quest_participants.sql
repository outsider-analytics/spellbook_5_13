{{
    config(
        alias='coinbase_wallet_quest_participants'
    )
}}

with 
 questers as (
    select quester_address, 'optimism' AS blockchain
    from {{ref('coinbase_wallet_quests_optimism_rewards_transfers')}}
    GROUP BY 1
  )
select
  blockchain,
  quester_address AS address,
  "Coinbase Wallet Quest Participant" AS name,
  "quests" AS category,
  "msilb7" AS contributor,
  "query" AS source,
  timestamp('2023-03-11') as created_at,
  CURRENT_TIMESTAMP() as updated_at,
  "coinbase_wallet_quest_participants" as model_name,
  "persona" as label_type
from
  questers