with source_data as (

    select
        date_trunc('day', to_timestamp_ntz(created_at:member0::string))::date as created_at
        , _airbyte_ab_id
        , first_name
        , last_name
        , email
        , total_spent
    from {{ source ("shopify", "customers") }}
)

select *
from source_data
