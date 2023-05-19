with source_data as (
    select
        _airbyte_unique_key, 
        id,
        customer_id,
        last_name,
        city,
        province,
        country_code,
        zip
    from {{ source ("shopify", "customers_addresses") }}
)


select *
from source_data
