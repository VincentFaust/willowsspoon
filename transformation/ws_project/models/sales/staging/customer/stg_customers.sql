
select 
    first_name 
    , last_name 
    , email 
    , total_spent
from {{ source ("shopify", "customers")}}