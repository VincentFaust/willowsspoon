{{
    config(
        materialized = "incremental", 
        unique_id = "_airbyte_ab_id"
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
        , shipping_address:country::string as country
        , shipping_address:latitude::string as latitude
        , shipping_address:longitude::string as longitude
        , shipping_address:first_name::string as first_name
        , shipping_address:last_name::string as last_name
        , TO_TIMESTAMP(created_at:member0::varchar) as created_at_ts
    from {{ source("shopify", "orders") }}
)

,

max_created_at as (
    select MAX(created_at_ts) as max_created_at_ts
    from source_data
)

select s.*
from source_data as s
left join max_created_at as m
    on s.created_at_ts > m.max_created_at_ts

{% if is_incremental() %}
    where m.max_created_at_ts is not null
{% endif %}
