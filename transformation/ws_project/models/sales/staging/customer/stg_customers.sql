{{
    config(
        materialized = "incremental", 
        unique_id = "_airbyte_unique_key"
    )
}}


with source_data as (

    select
        _airbyte_unique_key, 
        first_name,
        last_name,
        email,
        total_spent
    from {{ source ("shopify", "customers") }}
)

select *
from source_data

{% if is_incremental() %}
    where created_at > (select max(created_at) from {{ this }})
{% endif %}
