{{
    config(
        alias='contract_deployers_ethereum'
    )
}}

WITH creation AS (
    SELECT distinct 'ethereum'           AS blockchain
                  , ct.`from`            AS address
                  , 'Contract Deployer'  AS name
                  , 'infrastructure'     AS category
                  , 'hildobby'           AS contributor
                  , 'query'              AS source
                  , date('2023-03-03')   AS created_at
                  , CURRENT_TIMESTAMP()                AS updated_at
                  , 'contract_deployers' AS model_name
                  , 'persona'            AS label_type
    FROM {{ source('ethereum', 'creation_traces') }} ct
)
SELECT *
FROM creation
LEFT ANTI JOIN {{ source('ethereum', 'creation_traces') }} anti_table
ON creation.address = anti_table.address