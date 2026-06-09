/*
File: distinct_values.sql
Purpose: Explore distinct values in important categorical columns.
Author: Tony Blair
Date: 2026-06-09
*/
-- Distinct customer countries
SELECT DISTINCT country
FROM HBP_PRACTICE.RAW.CUSTOMERS
ORDER BY country;

-- Distinct customer active statuses
SELECT DISTINCT is_active
FROM HBP_PRACTICE.RAW.CUSTOMERS
ORDER BY is_active;

-- Distinct product categories
SELECT DISTINCT category
FROM HBP_PRACTICE.RAW.PRODUCTS
ORDER BY category;

-- Distinct order statuses
SELECT DISTINCT status
FROM HBP_PRACTICE.RAW.ORDERS
ORDER BY status;