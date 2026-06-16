-- =================================================
-- Model: mart_customer_summary
-- Purpose: Gold layer customer analytics mart
-- Description: One row per customer with profile data
--              and aggregated order behavior
-- Source: staging + intermediate layers
-- =================================================

with customers as (

    select *
    from {{ ref('stg_customers') }}

),

customer_metrics as (

    select *
    from {{ ref('int_customer_order_history') }}

)

select
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.country,
    c.created_at,
    c.is_active,

    -- aggregated metrics (may be NULL for customers with no orders)
    m.total_spend_pence,
    m.spend_rank,
    m.spend_dense_rank,

    -- gold layer metadata
    current_timestamp() as dbt_updated_at

from customers c

left join customer_metrics m
    on c.customer_id = m.customer_id