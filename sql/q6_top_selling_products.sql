-- =================================================
-- File: q6_top_selling_products.sql
-- Purpose: Return products where total quantity
-- ordered exceeds 2 for completed and pending orders.
-- Source: HBP_PRACTICE.RAW
-- Created: [11/06/2026]
-- =================================================

USE DATABASE  HBP_PRACTICE;
USE SCHEMA    RAW;
USE WAREHOUSE PRACTICE_WH;
SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

SELECT
    product_name,

    SUM(TRY_TO_NUMBER(quantity))
        AS total_quantity_ordered

FROM ORDERS

WHERE LOWER(status)
    IN ('completed', 'pending')

GROUP BY product_name

HAVING SUM(TRY_TO_NUMBER(quantity)) > 2

ORDER BY total_quantity_ordered DESC;