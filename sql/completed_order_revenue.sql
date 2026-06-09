/*
File: completed_order_revenue.sql
Purpose: Calculate total revenue from completed orders.
Author: Tony Blair
Date: 2026-06-09
*/
SELECT
    SUM(
        TRY_TO_NUMBER(quantity) *
        TRY_TO_NUMBER(unit_price_pence)
    ) AS total_revenue_pence
FROM HBP_PRACTICE.RAW.ORDERS
WHERE LOWER(status) = 'completed';