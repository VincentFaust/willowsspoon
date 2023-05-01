with stg_orders_billing_address as (
    select *
    from {{ ref("stg_orders_billing_address") }}
)

,

transformed as (
    select distinct
        {{ dbt_utils.surrogate_key(["address1","zip","city"]) }} as location_key
        , *
    from stg_orders_billing_address
)

select *
from transformed
