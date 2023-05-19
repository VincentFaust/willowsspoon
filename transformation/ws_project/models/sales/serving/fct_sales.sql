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
        , product_id
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

    from sales
)

select *
from final
