-- =================================================
-- File: q16_customer_spend_quartiles.sql
-- Purpose: Divide customers into spend quartiles
-- using NTILE(4) based on completed order spend.
-- Source: HBP_PRACTICE.RAW
-- Created: [12/06/2026]
-- =================================================

USE DATABASE  HBP_PRACTICE;
USE SCHEMA    RAW;
USE WAREHOUSE PRACTICE_WH;

SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

WITH customer_spend AS (

    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,

        -- Include all customers; customers with no completed
        -- orders receive a spend value of 0
        COALESCE(
            SUM(
                CASE
                    WHEN LOWER(o.status) = 'completed'
                    THEN TRY_TO_NUMBER(o.quantity)
                         * TRY_TO_NUMBER(o.unit_price_pence)
                    ELSE 0
                END
            ),
            0
        ) AS total_spend_pence

    FROM CUSTOMERS c

    LEFT JOIN ORDERS o
        ON c.customer_id = o.customer_id

    GROUP BY
        c.customer_id,
        customer_name
)

SELECT
    customer_id,
    customer_name,
    total_spend_pence,

    -- Divide customers into four approximately equal groups
    NTILE(4) OVER (
        ORDER BY total_spend_pence DESC
    ) AS spend_quartile

FROM customer_spend

ORDER BY
    spend_quartile,
    total_spend_pence DESC;

--Note: Snowflake distributes rows as evenly as possible. If the number of rows is not perfectly divisible by the number of buckets, earlier buckets receive the extra rows.
    