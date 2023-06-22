with sales as (
    select
        _airbyte_unique_key
        , _airbyte_orders_hashid
        , line_item_id
        , price
        , title
        , product_id
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
    inner join {{ ref("stg_orders_line_items") }}
        using (_airbyte_orders_hashid)
)

,
final as (
    select
        {{ dbt_utils.surrogate_key(["_airbyte_unique_key", "product_id", "line_item_id"]) }}
            as sales_key
        , title
        , product_id
        , order_number
        , price
        , total_price
        , {{ dbt_utils.surrogate_key(["created_at"]) }} as created_at_key
        , {{ dbt_utils.surrogate_key(["product_id"]) }} as product_key
        , {{ dbt_utils.surrogate_key(["address1","zip","city"]) }} as location_key
        , {{ dbt_utils.surrogate_key(["first_name", "last_name", "contact_email"]) }}
            as customer_identifier_key

    from sales
)

select *
from final
