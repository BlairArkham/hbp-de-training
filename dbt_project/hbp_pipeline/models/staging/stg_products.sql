with source as (

    select *
    from {{ source('raw', 'PRODUCTS') }}

),

cleaned as (

    select
        product_id,

        trim(product_name) as product_name,
        trim(category) as category,

        cast(unit_price_pence as integer) as unit_price_pence,

        lower(in_stock) = 'true' as in_stock

    from source
)

select *
from cleaned