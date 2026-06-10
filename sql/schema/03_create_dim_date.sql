
-- =================================================
-- File: 03_create_dim_date.sql
-- Table: HBP_ANALYTICS.MARTS.DIM_DATE
-- Purpose: Date dimension used for analytics and
-- reporting. One row per calendar day.
-- Source: Generated internally.
-- Created: [10/06/2026]
-- =================================================

USE DATABASE HBP_ANALYTICS;
USE SCHEMA MARTS;

CREATE TABLE IF NOT EXISTS DIM_DATE (
    date_id       DATE         NOT NULL COMMENT 'Unique date identifier',
    full_date     DATE                  COMMENT 'Full calendar date',
    year          INTEGER               COMMENT 'Calendar year',
    month         INTEGER               COMMENT 'Calendar month number',
    month_name    VARCHAR(20)           COMMENT 'Calendar month name',
    day           INTEGER               COMMENT 'Day of month',
    quarter       INTEGER               COMMENT 'Calendar quarter',
    day_of_week   VARCHAR(20)           COMMENT 'Day name',
    is_weekend    BOOLEAN               COMMENT 'Indicates weekend',
    PRIMARY KEY (date_id)
);
