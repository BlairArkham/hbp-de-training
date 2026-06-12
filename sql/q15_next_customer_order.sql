-- =================================================
-- File: q15_next_customer_order.sql
-- Purpose: Retrieve each customer's next ordered
-- product and order date using LEAD().
-- Last orders should return NULL.
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

    -- Product in the customer's next order
    LEAD(product_name) OVER (

        PARTITION BY customer_id

        ORDER BY
            TRY_TO_DATE(ordered_at)

    ) AS next_product,

    -- Date of the customer's next order
    LEAD(
        TRY_TO_DATE(ordered_at)
    ) OVER (

        PARTITION BY customer_id

        ORDER BY
            TRY_TO_DATE(ordered_at)

    ) AS next_order_date

FROM ORDERS

ORDER BY
    customer_id,
    TRY_TO_DATE(ordered_at);