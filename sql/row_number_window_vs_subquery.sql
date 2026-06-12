-- =================================================
-- File: q17_row_number_window_vs_subquery.sql
-- Purpose: Compare ROW_NUMBER() using a window
-- function versus a correlated subquery.
-- Source: HBP_PRACTICE.RAW
-- Created: [12/06/2026]
-- =================================================

USE DATABASE  HBP_PRACTICE;
USE SCHEMA    RAW;
USE WAREHOUSE PRACTICE_WH;

SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

-- ===============================================
-- Version 1: Window Function Approach
-- ===============================================

SELECT
    order_id,
    customer_id,
    product_name,
    ordered_at,

    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY TRY_TO_DATE(ordered_at)
    ) AS order_sequence

FROM ORDERS

ORDER BY
    customer_id,
    order_sequence;


-- ===============================================
-- Version 2: Correlated Subquery Approach
-- ===============================================

SELECT
    o1.order_id,
    o1.customer_id,
    o1.product_name,
    o1.ordered_at,

    (
        SELECT COUNT(*)
        FROM ORDERS o2
        WHERE o2.customer_id = o1.customer_id
          AND TRY_TO_DATE(o2.ordered_at)
              <= TRY_TO_DATE(o1.ordered_at)
    ) AS order_sequence

FROM ORDERS o1

ORDER BY
    customer_id,
    order_sequence;
    