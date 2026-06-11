-- =================================================
-- File: q1_full_table_preview.sql
-- Purpose: Preview all records from the raw tables.
-- Source: HBP_PRACTICE.RAW
-- Created: [11/06/2026]
-- =================================================

USE DATABASE  HBP_PRACTICE;
USE SCHEMA    RAW;
USE WAREHOUSE PRACTICE_WH;
SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

SELECT * FROM CUSTOMERS;

SELECT * FROM PRODUCTS;

SELECT * FROM ORDERS;