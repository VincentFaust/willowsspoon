with source_data as (

    select
        first_name,
        last_name,
        email,
        total_spent
    from {{ source ("shopify", "customers") }}
)

select *
from source_data
