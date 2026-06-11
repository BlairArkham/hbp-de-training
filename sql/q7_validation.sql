USE DATABASE  HBP_PRACTICE;
USE SCHEMA    RAW;
USE WAREHOUSE PRACTICE_WH;
SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_WAREHOUSE();

-- Validate q7 output
-- All 8 customers must appear
SELECT COUNT(*) AS total_customers FROM (
    WITH order_metrics AS (
        SELECT
            customer_id,
            COUNT(order_id)                                               AS total_orders,
            COUNT(CASE WHEN LOWER(status) = 'completed' THEN 1 END)      AS completed_orders,
            SUM(CASE WHEN LOWER(status) = 'completed'
                     THEN CAST(quantity AS INTEGER) * CAST(unit_price_pence AS INTEGER)
                     ELSE 0 END)                                          AS total_spend_pence
        FROM ORDERS
        GROUP BY customer_id
    )
    SELECT c.customer_id
    FROM CUSTOMERS c
    LEFT JOIN order_metrics om ON c.customer_id = om.customer_id
) AS validation_query;
-- Expected: 8