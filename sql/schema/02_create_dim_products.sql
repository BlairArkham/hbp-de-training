-- =================================================
-- File: 02_create_dim_products.sql
-- Table: HBP_RAW.INGEST.DIM_PRODUCTS
-- Purpose: Raw product dimension — landed from CSV
-- via Python ingestion script.
-- Columns are VARCHAR to preserve raw data as-is.
-- Cleaning and type-casting happens in dbt staging layer
-- (stg_products.sql).
-- Source: products.csv
-- Created: [10/06/2026]
-- =================================================

USE DATABASE HBP_RAW;
USE SCHEMA INGEST;

CREATE TABLE IF NOT EXISTS DIM_PRODUCTS (
    product_id         VARCHAR(20)    NOT NULL COMMENT 'Unique product identifier',
    product_name       VARCHAR(255)            COMMENT 'Product name from source file',
    category           VARCHAR(100)            COMMENT 'Product category',
    unit_price_pence   VARCHAR(50)             COMMENT 'Product price stored as text',
    in_stock           VARCHAR(10)             COMMENT 'Stock availability stored as text true/false',
    PRIMARY KEY (product_id)
);

