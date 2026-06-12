-- =================================================
-- File: q14_days_since_previous_order.sql
-- Purpose: Calculate the number of days since
-- each customer's previous order using LAG().
-- First orders should return NULL.
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
    ordered_at,

    -- Previous order date for the same customer
    LAG(
        TRY_TO_DATE(ordered_at)
    ) OVER (

        PARTITION BY customer_id

        ORDER BY
            TRY_TO_DATE(ordered_at)

    ) AS previous_order_date,

    -- Difference in days from previous order
    DATEDIFF(
        'day',

        LAG(
            TRY_TO_DATE(ordered_at)
        ) OVER (

            PARTITION BY customer_id

            ORDER BY
                TRY_TO_DATE(ordered_at)

        ),

        TRY_TO_DATE(ordered_at)

    ) AS days_since_previous_order

FROM ORDERS

ORDER BY
    customer_id,
    TRY_TO_DATE(ordered_at);