with source_data as (
    select 
        city 
        , province
        , country_code 
        , zip
        , address1
        , latitude 
        , longitude 
    from {{source("shopify", "orders_billing_address")}}
)

select *
from source_data


