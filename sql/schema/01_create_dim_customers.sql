-- =================================================
-- Table: HBP_RAW.INGEST.DIM_CUSTOMERS
-- Purpose: Raw customer dimension — landed from CSV via Python ingestion script
-- Columns are VARCHAR to preserve raw data as-is
-- Cleaning and type-casting happens in dbt staging layer (stg_customers.sql)
-- Created: [10/06/2026]
-- =================================================

USE DATABASE HBP_RAW;
USE SCHEMA INGEST;

CREATE TABLE IF NOT EXISTS DIM_CUSTOMERS (
   customer_id      VARCHAR(50)    NOT NULL COMMENT 'Unique customer identifier',
   first_name       VARCHAR(100)             COMMENT 'Customer first name — may have whitespace',
   last_name        VARCHAR(100)             COMMENT 'Customer last name — may have whitespace',
   email            VARCHAR(255)             COMMENT 'Email address — mixed case in raw data',
   country          VARCHAR(10)              COMMENT 'Two-letter country code — lowercase in raw',
   created_at       VARCHAR(50)              COMMENT 'Account creation date — stored as string',
   is_active        VARCHAR(10)              COMMENT 'Active status — stored as text true/false',
   PRIMARY KEY (customer_id)
);