-- =================================================
-- File: q2_customer_orders.sql
-- Purpose: Return active customers and their orders.
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
    o.order_id,
    o.product_name,
    o.quantity,
    o.status,
    o.ordered_at
FROM CUSTOMERS c
INNER JOIN ORDERS o
    ON c.customer_id = o.customer_id
WHERE LOWER(c.is_active) = 'true'
ORDER BY c.customer_id, o.order_id;