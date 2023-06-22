with source_data as (

    select
        date_trunc("day", created_at)::date as created_at
        , _airbyte_unique_key
        , first_name
        , last_name
        , email
        , total_spent
    from {{ source ("shopify", "customers") }}
)

select *
from source_data
