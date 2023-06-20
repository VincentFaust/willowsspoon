with source_data as (
    select
        row_number() over (order by (select null)) as unique_id 
        , id
        , customer_id
        , last_name
        , city
        , province
        , country_code
        , zip
    from {{ source ("shopify", "customers_addresses") }}
)


select *
from source_data
