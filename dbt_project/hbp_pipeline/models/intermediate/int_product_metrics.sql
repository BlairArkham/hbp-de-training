-- =================================================
-- Model: int_product_metrics
-- Purpose: Aggregate product revenue and rank products
-- Source: staging layer
-- =================================================

with product_performance as (

    select
        product_name,

        sum(quantity * unit_price_pence) as total_revenue_pence

    from {{ ref('stg_orders') }}

    where lower(status) = 'completed'

    group by product_name
)

select
    product_name,
    total_revenue_pence,

    row_number() over (
        order by total_revenue_pence desc
    ) as revenue_rank

from product_performance