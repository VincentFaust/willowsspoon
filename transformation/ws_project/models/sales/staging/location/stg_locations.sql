with source_data as (

    select 
        lon 
        , lat 
        , street 
        , postcode 
        , case 
            when country = 'us' then 'United States'
            when country = 'ca' then 'Canada'
          end as country 
    from {{ source("snowflake_marketplace", "openaddress")}}
    where country in ('us', 'ca')
        and street is not null 
        and country is not null 
)

select 
    row_number() over(order by (select null)) as unique_id
    , *
from source_data




