{{config(
    materialized = "incremental", 
    unique_key = "_airbyte_products_hashid", 
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

