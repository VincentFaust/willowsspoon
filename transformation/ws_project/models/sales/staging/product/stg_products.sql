{{config(
    materialized = "incremental", 
    unique_key = "created_at", 
    strategy = "delete+insert"
)}}


with source_data as (
select 
    created_at
    , handle 
    , _airbyte_products_hashid
from {{source("shopify", "products")}})


select *
from source_data 

