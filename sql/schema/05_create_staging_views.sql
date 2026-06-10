-- =================================================
-- File: 05_create_staging_views.sql
-- Purpose: Create placeholder staging views in
-- HBP_ANALYTICS.STAGING. These views will later
-- contain dbt transformations and data cleaning logic.
-- Source: Raw ingest tables.
-- Created: [10/06/2026]
-- =================================================

USE DATABASE HBP_ANALYTICS;
USE SCHEMA STAGING;

-- Customer staging view placeholder
CREATE OR REPLACE VIEW STG_CUSTOMERS AS
SELECT *
FROM HBP_RAW.INGEST.DIM_CUSTOMERS
WHERE 1 = 0;

-- Product staging view placeholder
CREATE OR REPLACE VIEW STG_PRODUCTS AS
SELECT *
FROM HBP_RAW.INGEST.DIM_PRODUCTS
WHERE 1 = 0;

-- Order staging view placeholder
CREATE OR REPLACE VIEW STG_ORDERS AS
SELECT *
FROM HBP_RAW.INGEST.FCT_ORDERS
WHERE 1 = 0;

-- Date staging view placeholder
CREATE OR REPLACE VIEW STG_DATE AS
SELECT *
FROM HBP_ANALYTICS.MARTS.DIM_DATE
WHERE 1 = 0;