with monthly_customers as (
    select
        sales.customer_identifier_key
        , date_trunc('month', dates.date_day) as month
    from {{ ref("fct_sales") }} as sales
    inner join {{ ref("dim_dates") }} as dates
        on sales.created_at_key = dates.date_key
    group by
        month, sales.customer_identifier_key
)

, previous_month_customers as (
    select
        month
        , customer_identifier_key
        , lag(customer_identifier_key) over (partition by customer_identifier_key order by month) as prev_month_customer
    from monthly_customers
)

, return_rate as (
    select
        month
        , count(distinct customer_identifier_key) as total_customers
        , count(distinct case when prev_month_customer is not null then customer_identifier_key end) as returning_customers
        , count(distinct case when prev_month_customer is not null then customer_identifier_key end)::float / nullif(count(distinct customer_identifier_key), 0) as return_rate
    from
        previous_month_customers
    group by
        month
)

select *
from return_rate
order by month
