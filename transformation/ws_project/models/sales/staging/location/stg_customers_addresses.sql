with source_data as (
    select
        id
        , customer_id
        , last_name
        , city
        , province
        , country_code
        , zip
        , row_number() over (order by (select null)) as unique_id
    from {{ source ("shopify", "customers_addresses") }}
)


select *
from source_data
