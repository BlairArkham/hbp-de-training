/*
File: active_customers.sql
Purpose: Retrieve active customers.
Author: Tony Blair
Date: 2026-06-09
*/
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    country,
    created_at,
    is_active
FROM HBP_PRACTICE.RAW.CUSTOMERS
WHERE LOWER(is_active) = 'true'
ORDER BY customer_id;