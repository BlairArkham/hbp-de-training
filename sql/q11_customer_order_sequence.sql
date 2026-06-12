-- =================================================
-- File: q11_customer_order_sequence.sql
-- Purpose: Rank each customer's orders from oldest
-- to newest using ROW_NUMBER().
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
    product_name,
    ordered_at,

    -- Restart numbering for each customer
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY TRY_TO_DATE(ordered_at)
    ) AS order_sequence

FROM ORDERS

ORDER BY
    customer_id,
    order_sequence;