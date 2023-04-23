with stg_date as (
    select * from {{ ref("stg_date")}}
)

,

transformed as (
    select 
        {{ dbt_utils.surrogate_key(["date_day"])}} as date_key 
        , *
    from stg_date
)

select *
from transformed