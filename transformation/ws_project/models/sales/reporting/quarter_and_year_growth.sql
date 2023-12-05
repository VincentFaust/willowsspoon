with yearly_sales as (
    select
        extract(year from dates.date_day) as year
        , sum(sales.total_price) as total_yearly_sales
        , lag(sum(sales.total_price)) over (order by extract(year from dates.date_day)) as previous_year_sales
        , (sum(sales.total_price) - lag(sum(sales.total_price)) over (order by extract(year from dates.date_day))) / lag(sum(sales.total_price)) over (order by extract(year from dates.date_day)) as year_pct_change
    from {{ ref("fct_sales") }} as sales
    inner join {{ ref("dim_dates") }} as dates
        on sales.created_at_key = dates.date_key
    group by extract(year from dates.date_day)
)

, quarterly_sales as (
    select
        extract(year from dates.date_day) as year
        , extract(quarter from dates.date_day) as quarter
        , sum(sales.total_price) as quarterly_total_sales
        , lag(sum(sales.total_price)) over (order by extract(year from dates.date_day), extract(quarter from dates.date_day)) as previous_quarter_sales
        , (sum(sales.total_price) - lag(sum(sales.total_price)) over (order by extract(year from dates.date_day), extract(quarter from dates.date_day))) / lag(sum(sales.total_price)) over (order by extract(year from dates.date_day), extract(quarter from dates.date_day)) as quarter_pct_change
    from {{ ref("fct_sales") }} as sales
    inner join {{ ref("dim_dates") }} as dates
        on sales.created_at_key = dates.date_key
    group by extract(year from dates.date_day), extract(quarter from dates.date_day)
)

select
    q.year
    , q.quarter
    , q.quarterly_total_sales
    , q.previous_quarter_sales
    , q.quarter_pct_change
    , y.total_yearly_sales as annual_sales
    , y.previous_year_sales
    , y.year_pct_change
from quarterly_sales as q
inner join yearly_sales as y
    on q.year = y.year
order by
    q.year
    , q.quarter
