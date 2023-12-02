with stg_locations as (
    select *
    from {{ ref("stg_locations") }}
)

, 

transformed as  (
    select
        {{ dbt_utils.surrogate_key(["lon", "lat", "street", "postcode", "country"])}} as location_key
    from stg_locations
)

select *
from transformed

