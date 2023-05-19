with source_data as (
    select
        _airbyte_orders_hashid 
        , title 
        , price 
        , product_id
        , sku 
        , quantity 
    from {{ source("shopify", "orders_line_items")}}
    where product_exists = TRUE
)

select *
from source_data 
