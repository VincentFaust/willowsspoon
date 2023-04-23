with stg_customers_addresses as (
    select * from {{ref("stg_customers_addresses")}}
)

,

transformed as (
    select
        {{dbt_utils.surrogate_key(["id","customer_id"])}} as location_key 
        , * 
    from stg_customers_addresses
)

select *
from transformed