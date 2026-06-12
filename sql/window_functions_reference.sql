-- =================================================
-- File: snippets/window_functions_reference.sql
-- Purpose: Reusable window function reference
-- for analytics engineering work.
-- Created: [12/06/2026]
-- =================================================

/* =================================================
1. ROW_NUMBER()
Assigns a unique sequential number within each group.
================================================= */

select
    customer_id,
    order_id,
    row_number() over (
        partition by customer_id
        order by ordered_at
    ) as order_rank
from orders;


/* =================================================
2. RANK() vs DENSE_RANK()
RANK skips numbers after ties.
DENSE_RANK does not skip numbers.
================================================= */

select
    customer_id,
    total_spend,
    rank() over (
        order by total_spend desc
    ) as spend_rank,
    dense_rank() over (
        order by total_spend desc
    ) as spend_dense_rank
from customer_spend;


/* =================================================
3. LAG()
Returns a value from the previous row.
================================================= */

select
    customer_id,
    ordered_at,
    lag(ordered_at) over (
        partition by customer_id
        order by ordered_at
    ) as previous_order_date
from orders;


/* =================================================
4. LEAD()
Returns a value from the next row.
================================================= */

select
    customer_id,
    ordered_at,
    lead(product_name) over (
        partition by customer_id
        order by ordered_at
    ) as next_product
from orders;


/* =================================================
5. Running Totals
Uses a window frame to calculate cumulative values.
================================================= */

select
    ordered_at,
    line_total_pence,
    sum(line_total_pence) over (
        order by ordered_at
        rows between unbounded preceding
        and current row
    ) as running_total
from orders;


/* =================================================
6. NTILE()
Divides rows into approximately equal groups.
================================================= */

select
    customer_id,
    total_spend,
    ntile(4) over (
        order by total_spend desc
    ) as spend_quartile
from customer_spend;


/* =================================================
7. FIRST_VALUE() and LAST_VALUE()

FIRST_VALUE:
Returns the first value in the window frame.

LAST_VALUE:
Returns the last value in the CURRENT window frame.

Important:
LAST_VALUE() often requires an explicit frame,
otherwise it returns the current row's value.

Use FIRST_VALUE:
- First purchase date
- First product purchased

Use LAST_VALUE:
- Most recent status
- Latest transaction amount
================================================= */

select
    customer_id,
    ordered_at,

    first_value(product_name) over (
        partition by customer_id
        order by ordered_at
    ) as first_product,

    last_value(product_name) over (
        partition by customer_id
        order by ordered_at
        rows between unbounded preceding
        and unbounded following
    ) as last_product

from orders;

