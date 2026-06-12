-- =================================================
-- File: q17_product_metrics.sql
-- Purpose: Generate product-level performance
-- metrics including revenue ranking.
--
-- Future dbt model: int_product_metrics
--
-- Source:
--   - HBP_PRACTICE.RAW.PRODUCTS
--   - HBP_PRACTICE.RAW.ORDERS
--
-- Grain:
--   One row per product.
--
-- Created: [12/06/2026]
-- =================================================
use warehouse practice_wh;
use database hbp_practice;
use schema raw;

with product_orders as (

    select
        p.product_id,
        p.product_name,
        p.category,
        lower(p.in_stock) as in_stock,

        o.order_id,
        try_to_number(o.quantity) as quantity,
        try_to_number(o.unit_price_pence) as unit_price_pence,
        lower(o.status) as status

    from products as p

    left join orders as o
        on p.product_name = o.product_name

),

product_metrics as (

    select
        product_id,
        product_name,
        category,
        in_stock,

        count(
            case
                when status = 'completed'
                then order_id
            end
        ) as total_orders,

        coalesce(
            sum(
                case
                    when status = 'completed'
                    then quantity
                    else 0
                end
            ),
            0
        ) as total_quantity_sold,

        coalesce(
            sum(
                case
                    when status = 'completed'
                    then quantity * unit_price_pence
                    else 0
                end
            ),
            0
        ) as total_revenue_pence,

        coalesce(
            round(
                sum(
                    case
                        when status = 'completed'
                        then quantity
                        else 0
                    end
                )
                /
                nullif(
                    count(
                        case
                            when status = 'completed'
                            then order_id
                        end
                    ),
                    0
                ),
                2
            ),
            0
        ) as avg_quantity_per_order

    from product_orders

    group by
        product_id,
        product_name,
        category,
        in_stock

)

select
    *,
    
    dense_rank() over (
        order by total_revenue_pence desc
    ) as rank_by_revenue

from product_metrics

order by rank_by_revenue;
