with customer_rev as (
    select
        customer_identifier_key
        , first_name
        , last_name
        , sum(total_price) as total_rev
    from {{ ref("fct_sales") }} as sales
    inner join {{ ref("dim_customers") }} as customers
        on sales.customer_identifier_key = customers.customer_key
    group by customer_identifier_key, first_name, last_name
)

select
    first_name
    , last_name
    , total_rev
    , rank() over (order by total_rev desc) as ranked_total_rev
from customer_rev
qualify rank() over (order by total_rev desc) < 11
