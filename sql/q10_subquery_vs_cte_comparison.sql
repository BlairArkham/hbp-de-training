-- =================================================
-- File: q10_subquery_vs_cte_comparison.sql
-- Purpose: Compare CTE and subquery approaches for
-- identifying high-spend customers.
-- Source: HBP_PRACTICE.RAW
-- Created: [11/06/2026]
-- =================================================

USE DATABASE  HBP_PRACTICE;
USE SCHEMA    RAW;
USE WAREHOUSE PRACTICE_WH;
SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

-- ==========================================
-- CTE VERSION
-- ==========================================

WITH customer_spend AS (

    SELECT
        customer_id,

        SUM(
            TRY_TO_NUMBER(quantity)
            * TRY_TO_NUMBER(unit_price_pence)
        ) AS total_spend_pence

    FROM ORDERS

    WHERE LOWER(status) = 'completed'

    GROUP BY customer_id
)

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    cs.total_spend_pence

FROM customer_spend cs

INNER JOIN CUSTOMERS c
    ON cs.customer_id = c.customer_id

WHERE cs.total_spend_pence > 10000

ORDER BY total_spend_pence DESC;


-- ==========================================
-- SUBQUERY VERSION
-- ==========================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    hs.total_spend_pence

FROM (

    SELECT
        customer_id,

        SUM(
            TRY_TO_NUMBER(quantity)
            * TRY_TO_NUMBER(unit_price_pence)
        ) AS total_spend_pence

    FROM ORDERS

    WHERE LOWER(status) = 'completed'

    GROUP BY customer_id

) hs

INNER JOIN CUSTOMERS c
    ON hs.customer_id = c.customer_id

WHERE hs.total_spend_pence > 10000

ORDER BY total_spend_pence DESC;