
select 
    created_at
    , handle 
from {{source("shopify", "products")}}

