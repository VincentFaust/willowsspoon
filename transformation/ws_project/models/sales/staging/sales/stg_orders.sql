with source_data as (
select 
    created_at
    , checkout_id
    , current_total_tax 
    , order_number
    , total_price
from {{source("shopify", "orders")}})


select 
    *
from source_data 
