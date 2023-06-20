with source_data as (

    select
        price
        , grams
        , _airbyte_products_hashid
    from {{ source("shopify", "products_variants") }}
)



select *
from source_data
