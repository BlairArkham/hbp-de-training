-- =================================================
-- File: 04_create_fct_orders.sql
-- Table: HBP_ANALYTICS.MARTS.FCT_ORDERS
-- Purpose: Fact table containing customer orders
-- for analytical reporting.
-- Source: orders.csv transformed through dbt.
-- Created: [10/06/2026]
-- =================================================

USE DATABASE HBP_ANALYTICS;
USE SCHEMA MARTS;

CREATE TABLE IF NOT EXISTS FCT_ORDERS (
    order_id           INTEGER      NOT NULL  COMMENT 'Unique order identifier',
    customer_id        INTEGER      NOT NULL  COMMENT 'Foreign key to DIM_CUSTOMERS',
    product_id         VARCHAR(36)  NOT NULL  COMMENT 'Foreign key to DIM_PRODUCTS',
    date_id            DATE         NOT NULL  COMMENT 'Foreign key to DIM_DATE',
    quantity           INTEGER      NOT NULL  COMMENT 'Quantity ordered',
    unit_price_pence   INTEGER      NOT NULL  COMMENT 'Unit price at time of order in pence',
    line_total_pence   INTEGER      NOT NULL  COMMENT 'Quantity × unit price in pence',
    status             VARCHAR(20)  NOT NULL  COMMENT 'Order status: pending | shipped | returned | cancelled',

    PRIMARY KEY (order_id),

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)  REFERENCES DIM_CUSTOMERS(customer_id)  RELY,
    CONSTRAINT fk_orders_product
        FOREIGN KEY (product_id)   REFERENCES DIM_PRODUCTS(product_id)    RELY,
    CONSTRAINT fk_orders_date
        FOREIGN KEY (date_id)      REFERENCES DIM_DATE(date_id)           RELY
)
CLUSTER BY (date_id, customer_id)
DATA_RETENTION_TIME_IN_DAYS = 7
COMMENT = 'Fact table of customer orders. Grain: one row per order. Source: orders.csv via dbt.';