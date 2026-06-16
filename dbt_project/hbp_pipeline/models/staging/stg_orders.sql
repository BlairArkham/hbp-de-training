with source as (

    select *
    from {{ source('raw', 'ORDERS') }}

),

cleaned as (

    select
        cast(order_id as integer) as order_id,
        cast(customer_id as integer) as customer_id,

        product_name,
        cast(quantity as integer) as quantity,
        cast(unit_price_pence as integer) as unit_price_pence,

        lower(trim(status)) as status,

        cast(ordered_at as date) as ordered_at,

        -- business logic column (Silver transformation)
        quantity * unit_price_pence as line_total_pence

    from source
)

select *
from cleaned