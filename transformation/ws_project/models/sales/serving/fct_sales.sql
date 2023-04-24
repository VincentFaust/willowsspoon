with sales as (
    select * from {{ref("stg_orders")}}
)

select
    {{dbt_utils.surrogate_key(["checkout_id", "order_number"])}} as sales_key 
    , checkout_id
    , current_total_tax 
    , order_number
    , total_price

from sales