-- =================================================
-- File: q13_running_revenue_total.sql
-- Purpose: Calculate cumulative revenue for
-- completed orders in chronological order.
-- Source: HBP_PRACTICE.RAW.ORDERS
-- Created: [12/06/2026]
-- =================================================

USE DATABASE  HBP_PRACTICE;
USE SCHEMA    RAW;
USE WAREHOUSE PRACTICE_WH;

SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

SELECT
    order_id,
    customer_id,
    ordered_at,

    TRY_TO_NUMBER(quantity)
    * TRY_TO_NUMBER(unit_price_pence)
        AS line_total_pence,

    -- Running total from first order to current order
    SUM(
        TRY_TO_NUMBER(quantity)
        * TRY_TO_NUMBER(unit_price_pence)
    ) OVER (

        ORDER BY
            TRY_TO_DATE(ordered_at)

        ROWS BETWEEN
            UNBOUNDED PRECEDING
            AND CURRENT ROW

    ) AS cumulative_revenue_pence

FROM ORDERS

WHERE LOWER(status) = 'completed'

ORDER BY TRY_TO_DATE(ordered_at);