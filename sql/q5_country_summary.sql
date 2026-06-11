-- =================================================
-- File: q5_country_summary.sql
-- Purpose: Summarise customers, active customers,
-- orders and completed order revenue by country.
-- Source: HBP_PRACTICE.RAW
-- Created: [11/06/2026]
-- =================================================

USE DATABASE  HBP_PRACTICE;
USE SCHEMA    RAW;
USE WAREHOUSE PRACTICE_WH;
SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

SELECT
    UPPER(c.country) AS country,

    COUNT(DISTINCT c.customer_id) AS total_customers,

    COUNT(DISTINCT CASE
        WHEN LOWER(c.is_active) = 'true'
        THEN c.customer_id
    END) AS active_customers,

    COUNT(o.order_id) AS total_orders,

    SUM(CASE
        WHEN LOWER(o.status) = 'completed'
        THEN TRY_TO_NUMBER(o.quantity)
             * TRY_TO_NUMBER(o.unit_price_pence)
        ELSE 0
    END) AS completed_revenue_pence

FROM CUSTOMERS c
LEFT JOIN ORDERS o
    ON c.customer_id = o.customer_id

GROUP BY UPPER(c.country)

ORDER BY country;