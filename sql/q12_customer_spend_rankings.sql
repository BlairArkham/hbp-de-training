-- =================================================
-- File: q12_customer_spend_rankings.sql
-- Purpose: Compare RANK() and DENSE_RANK() by
-- ranking customers based on completed order spend.
-- Source: HBP_PRACTICE.RAW
-- Created: [12/06/2026]
-- =================================================

USE DATABASE  HBP_PRACTICE;
USE SCHEMA    RAW;
USE WAREHOUSE PRACTICE_WH;

SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

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
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    cs.total_spend_pence,

    -- RANK skips numbers after ties
    RANK() OVER (
        ORDER BY cs.total_spend_pence DESC
    ) AS spend_rank,

    -- DENSE_RANK does not skip numbers after ties
    DENSE_RANK() OVER (
        ORDER BY cs.total_spend_pence DESC
    ) AS spend_dense_rank

FROM customer_spend cs

INNER JOIN CUSTOMERS c
    ON cs.customer_id = c.customer_id

ORDER BY spend_rank;