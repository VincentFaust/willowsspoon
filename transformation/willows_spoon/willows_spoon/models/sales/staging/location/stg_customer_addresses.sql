select 
    last_name
    , city 
    , province
    , country_code 
from {{ source ("raw_source", "customer_addresses")}}