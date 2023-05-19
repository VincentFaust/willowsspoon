with sales as (
    select
         _airbyte_unique_key
        , checkout_id
        , current_total_tax
        , order_number
        , total_price
        , address1
        , zip
        , city
        , contact_email
        , first_name
        , last_name
        , date(created_at) as created_at
    from {{ ref("stg_orders") }}

)

,
final as (
    select
        {{ dbt_utils.surrogate_key(["_airbyte_unique_key"]) }}
            as sales_key
        , checkout_id
        , current_total_tax
        , order_number
        , total_price
        , {{ dbt_utils.surrogate_key(["created_at"]) }} as created_at_key
        , {{ dbt_utils.surrogate_key(["address1","zip","city"]) }} as location_key
        , {{ dbt_utils.surrogate_key(["first_name", "last_name", "contact_email"]) }}
            as customer_identifier_key

    from sales
)

select *
from final
