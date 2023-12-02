with source_data as (
    select distinct
        parse_json(default_address):address1::string as address1
        , parse_json(default_address):city::string as city
        , parse_json(default_address):country::string as country
        , parse_json(default_address):province::string as state
        , parse_json(default_address):zip::string as zip
    from {{ source("shopify", "customers") }}
)

select
    address1
    , city
    , country
    , state
    , zip
    , row_number() over (order by (select null)) as unique_id
from source_data
