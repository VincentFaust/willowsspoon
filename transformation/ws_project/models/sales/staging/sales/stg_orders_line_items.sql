with source_data as (
    select
        _airbyte_orders_hashid
        , id
        , title
        , price
        , product_id
        , sku
        , quantity
        , row_number() over (partition by _airbyte_orders_hashid order by product_id) as line_item_id
    from {{ source("shopify", "orders_line_items") }}
    where product_exists = TRUE
)

select *
from source_data
