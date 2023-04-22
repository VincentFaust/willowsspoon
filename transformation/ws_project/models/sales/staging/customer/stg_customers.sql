{{config(
    materialized = "incremental", 
    unique_key = "updated_at", 
    strategy = "delete+insert"
)}}


select 
    updated_at
    , first_name 
    , last_name 
    , email 
    , total_spent
from {{ source ("shopify", "customers")}}