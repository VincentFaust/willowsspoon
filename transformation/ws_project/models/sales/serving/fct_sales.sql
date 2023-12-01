with sales as (
    select
        _airbyte_ab_id
        , current_total_tax
        , order_number
        , total_price
        , address1
        , zip
        , city
        , email
        , first_name
        , last_name
        , date(created_at) as created_at
    from {{ ref("stg_orders") }}
)

,
final as (
    select
        {{ dbt_utils.surrogate_key(["_airbyte_ab_id"]) }}
            as sales_key
        , order_number
        , total_price
        , {{ dbt_utils.surrogate_key(["created_at"]) }} as created_at_key
        , {{ dbt_utils.surrogate_key(["first_name", "last_name", "email"]) }}
            as customer_identifier_key

    from sales
)

select *
from final
