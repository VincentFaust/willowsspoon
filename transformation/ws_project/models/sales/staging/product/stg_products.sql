{{config(
    materialized = "incremental", 
    unique_key = "created_at", 
    strategy = "delete+insert"
)}}



select 
    created_at
    , handle 
from {{source("shopify", "products")}}

