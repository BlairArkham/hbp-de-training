-- =================================================
-- Model: int_customer_order_history
-- Purpose: Customer spend + ranking analysis
-- Source: staging layer
-- =================================================

with customer_spend as (

    select
        customer_id,

        sum(quantity * unit_price_pence) as total_spend_pence

    from {{ ref('stg_orders') }}

    where lower(status) = 'completed'

    group by customer_id
),

joined as (

    select
        c.customer_id,
        concat(c.first_name, ' ', c.last_name) as customer_name,
        cs.total_spend_pence

    from customer_spend cs

    inner join {{ ref('stg_customers') }} c
        on cs.customer_id = c.customer_id
)

select
    customer_id,
    customer_name,
    total_spend_pence,

    rank() over (
        order by total_spend_pence desc
    ) as spend_rank,

    dense_rank() over (
        order by total_spend_pence desc
    ) as spend_dense_rank

from joined