{{
    config(
        materialized = "incremental", 
        unique_id = "_airbyte_unique_key"
    )
}}

with source_data as (
    select
        created_at
        , _airbyte_ab_id
        , current_total_tax
        , order_number
        , total_price
        , email
        , shipping_address:zip::string as zip
        , shipping_address:address1::string as address1
        , shipping_address:city::string as city
        , shipping_address:latitude::string as latitude
        , shipping_address:longitude::string as longitude
        , shipping_address:first_name::string as first_name
        , shipping_address:last_name::string as last_name
    from {{ source("shopify", "orders") }}
)


select *
from source_data

{% if is_incremental() %}
    where created_at > (select max(created_at) from {{ this }})
{% endif %}
