with source_data as (
    select
        product_id,
        _airbyte_products_hashid
    from {{ source("shopify", "products_options") }}
)


select *
from source_data
