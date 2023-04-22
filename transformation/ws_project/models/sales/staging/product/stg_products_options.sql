with source_data as (
select 
    product_id 
from {{source("shopify", "products_options")}})


select *
from source_data 
