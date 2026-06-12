-- =================================================
-- File: q16_customer_order_history.sql
-- Purpose: Create a customer order history dataset
-- with customer context and window-derived metrics.
--
-- Future dbt model: int_customer_order_history
--
-- Source:
--   - HBP_PRACTICE.RAW.CUSTOMERS
--   - HBP_PRACTICE.RAW.ORDERS
--
-- Grain:
--   One row per customer order.
--
-- Created: [12/06/2026]
-- =================================================
use warehouse practice_wh;
use database hbp_practice;
use schema raw;

with customer_clean as (

    select
        customer_id,
        trim(first_name) as first_name,
        trim(last_name) as last_name,
        lower(email) as email,
        upper(country) as country,
        lower(is_active) as is_active

    from customers

),

customer_orders as (

    select
        o.order_id,
        o.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.country,
        c.is_active,
        o.product_name,
        try_to_number(o.quantity) as quantity,
        try_to_number(o.unit_price_pence) as unit_price_pence,
        try_to_date(o.ordered_at) as ordered_date,
        lower(o.status) as status,

        try_to_number(o.quantity)
            * try_to_number(o.unit_price_pence)
            as line_total_pence

    from orders as o

    inner join customer_clean as c
        on o.customer_id = c.customer_id

),

customer_order_history as (

    select
        *,

        -- Sequence orders chronologically for each customer
        row_number() over (
            partition by customer_id
            order by ordered_date
        ) as order_rank,

        -- Previous order date for the customer
        lag(ordered_date) over (
            partition by customer_id
            order by ordered_date
        ) as prev_order_date,

        -- Days since previous order
        datediff(
            day,
            lag(ordered_date) over (
                partition by customer_id
                order by ordered_date
            ),
            ordered_date
        ) as days_since_last_order,

        -- Running customer spend over time
        sum(line_total_pence) over (
            partition by customer_id
            order by ordered_date
            rows between unbounded preceding
            and current row
        ) as running_total_spend_pence

    from customer_orders

)

select *
from customer_order_history

order by
    customer_id,
    ordered_date;


