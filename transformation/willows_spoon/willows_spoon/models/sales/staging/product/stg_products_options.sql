select 
    title
    , price 
from from {{source("raw_source", "products_options")}}
