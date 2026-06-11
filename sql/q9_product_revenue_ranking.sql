-- =================================================
-- File: q9_product_revenue_ranking.sql
-- Purpose: Rank products by completed-order revenue.
-- Source: HBP_PRACTICE.RAW
-- Created: [11/06/2026]
-- =================================================

USE DATABASE  HBP_PRACTICE;
USE SCHEMA    RAW;
USE WAREHOUSE PRACTICE_WH;
SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

WITH product_performance AS (

    SELECT
        product_name,

        SUM(
            TRY_TO_NUMBER(quantity)
            * TRY_TO_NUMBER(unit_price_pence)
        ) AS total_revenue_pence

    FROM ORDERS

    WHERE LOWER(status) = 'completed'

    GROUP BY product_name
)

SELECT
    product_name,
    total_revenue_pence,

    ROW_NUMBER() OVER (
        ORDER BY total_revenue_pence DESC
    ) AS revenue_rank

FROM product_performance

ORDER BY revenue_rank;