-- =================================================
-- File: q8_customer_order_metrics.sql
-- Purpose: Return order metrics for all customers.
-- Includes all 8 customers.
-- Source: HBP_PRACTICE.RAW
-- Created: [11/06/2026]
-- =================================================

USE DATABASE  HBP_PRACTICE;
USE SCHEMA    RAW;
USE WAREHOUSE PRACTICE_WH;
SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

WITH customer_metrics AS (

    SELECT
        customer_id,

        COUNT(*) AS total_orders,

        COUNT(
            CASE
                WHEN LOWER(status) = 'completed'
                THEN 1
            END
        ) AS completed_orders,

        SUM(
            CASE
                WHEN LOWER(status) = 'completed'
                THEN TRY_TO_NUMBER(quantity)
                     * TRY_TO_NUMBER(unit_price_pence)
                ELSE 0
            END
        ) AS total_spend

    FROM ORDERS

    GROUP BY customer_id
)

SELECT
    c.customer_id,

    CONCAT(c.first_name, ' ', c.last_name)
        AS customer_name,

    COALESCE(cm.total_orders, 0)
        AS total_orders,

    COALESCE(cm.completed_orders, 0)
        AS completed_orders,

    COALESCE(cm.total_spend, 0)
        AS total_spend_pence,

    COALESCE(
        ROUND(
            cm.total_spend
            / NULLIF(cm.completed_orders, 0),
            2
        ),
        0
    ) AS avg_spend_per_completed_order

FROM CUSTOMERS c

LEFT JOIN customer_metrics cm
    ON c.customer_id = cm.customer_id

ORDER BY c.customer_id;