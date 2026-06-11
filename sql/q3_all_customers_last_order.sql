-- =================================================
-- File: q3_all_customers_last_order.sql
-- Purpose: Return every customer and their most
-- recent order date. Customers with no orders
-- should show NULL.
-- Source: HBP_PRACTICE.RAW
-- Created: [11/06/2026]
-- =================================================

USE DATABASE  HBP_PRACTICE;
USE SCHEMA    RAW;
USE WAREHOUSE PRACTICE_WH;
SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    MAX(TRY_TO_DATE(o.ordered_at)) AS last_order_date
FROM CUSTOMERS c
LEFT JOIN ORDERS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY c.customer_id;