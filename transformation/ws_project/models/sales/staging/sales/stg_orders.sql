{{
    config(
        materialized = "incremental", 
        unique_id = "_airbyte_unique_key"
    )
}}

with source_data as (
    select
        created_at,
        _airbyte_unique_key, 
        id, 
        checkout_id,
        current_total_tax,
        order_number,
        total_price,
        contact_email,
        billing_address:zip::string as zip,
        billing_address:address1::string as address1,
        billing_address:city::string as city,
        billing_address:first_name::string as first_name,
        billing_address:last_name::string as last_name,
        flattened.value:product_id::int as product_id
    from {{ source("shopify", "orders") }},
        lateral flatten(input => line_items) as flattened
    where flattened.value:product_exists = True
)


select *
from source_data

{% if is_incremental() %}
    where created_at > (select max(created_at) from {{ this }})
{% endif %}
