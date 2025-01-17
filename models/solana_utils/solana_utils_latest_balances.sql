 {{
  config(
        alias='latest_balances',
        materialized = 'view')
}}

WITH 
      updated_balances as (
            SELECT
                  address 
                  , `day`
                  , sol_balance
                  , token_mint_address
                  , token_balance
                  , token_balance_owner
                  , row_number() OVER (partition by address order by `day` desc) as latest_balance
            FROM {{ ref('solana_utils_daily_balances') }}
      )

SELECT 
      address
      , sol_balance
      , token_balance
      , token_mint_address
      , token_balance_owner
      , CURRENT_TIMESTAMP() as updated_at 
FROM updated_balances
WHERE latest_balance = 1