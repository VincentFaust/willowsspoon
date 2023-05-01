with stg_products_options as (
    select * from {{ ref("stg_products_options") }}
)

,

stg_product_variants as (
    select * from {{ ref("stg_products_variants") }}
)

,

stg_products as (
    select * from {{ ref("stg_products") }}
),

transformed as (
    select
        {{ dbt_utils.surrogate_key(["product_id"]) }} as product_key
        , stg_products_options.product_id as product_id
        , stg_product_variants.price as price
        , stg_product_variants.grams as grams
        , stg_products.handle as handle

    from stg_products_options
    inner join stg_product_variants
        on stg_products_options._airbyte_products_hashid = stg_product_variants._airbyte_products_hashid
inner join stg_products
    using (_airbyte_products_hashid)
)


select *
from transformed
