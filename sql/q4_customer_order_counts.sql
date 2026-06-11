-- =================================================
-- File: q4_customer_order_counts.sql
-- Purpose: Return customer details and order counts.
-- Customers without orders should show 0.
-- Source: HBP_PRACTICE.RAW
-- Created: [11/06/2026]
-- =================================================

USE DATABASE  HBP_PRACTICE;
USE SCHEMA    RAW;
USE WAREHOUSE PRACTICE_WH;
SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    UPPER(c.country) AS country,
    
    -- Replace NULL counts with 0
    COALESCE(COUNT(o.order_id), 0) AS order_count

FROM CUSTOMERS c
LEFT JOIN ORDERS o
    ON c.customer_id = o.customer_id

GROUP BY
    c.customer_id,
    full_name,
    country

ORDER BY c.customer_id;