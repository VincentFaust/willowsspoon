select
    state
    , city
    , count(*) as num_orders
    , sum(total_price) as total_geo_revenue
from {{ ref("fct_sales") }}
inner join {{ ref("dim_locations") }}
    using (location_key)
where city is not null
group by state, city
order by num_orders desc
