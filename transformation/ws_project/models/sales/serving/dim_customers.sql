with stg_customers as (
    select * from {{ ref("stg_customers") }}
)

,
--test 
transformed as (
    select
        {{ dbt_utils.surrogate_key(["first_name", "last_name", "email"]) }}
            as customer_key
        , *
    from stg_customers
)

select *
from transformed
