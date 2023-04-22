with source_data as (

select 
    price 
    , grams 
from {{source("shopify", "products_variants")}}
)



select *
from source_data


