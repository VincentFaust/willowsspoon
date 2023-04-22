{{config(
    materialized = "incremental", 
    unique_key = "id", 
    strategy = "delete+insert"
)}}


select 
    id 
    , last_name
    , city 
    , province
    , country_code 
from {{ source ("shopify", "customers_addresses")}}