select 
    last_name
    , city 
    , province
    , country_code 
from {{ source ("shopify", "customers_addresses")}}