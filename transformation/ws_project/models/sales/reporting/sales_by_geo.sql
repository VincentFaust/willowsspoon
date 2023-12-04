select 
    state
    , city  
    , count(*) as num_orders 
    , sum(total_price) as total_geo_revenue
from {{ref("fct_sales")}}   
join {{ref("dim_locations")}}         
    using(location_key)
where city is not null 
group by state, city
order by 3 desc 