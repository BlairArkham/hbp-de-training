-- =================================================
-- File: 00_setup_production_environment.sql
-- Purpose: Create production warehouses, databases,
-- and schemas required for the HBP analytics platform.
-- Run this ONCE before loading data.
-- Script is idempotent and safe to run multiple times.
-- Created: [10/06/2026]
-- =================================================

USE ROLE ACCOUNTADMIN;

-- Create production warehouse
CREATE WAREHOUSE IF NOT EXISTS HBP_WH
WITH
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;

-- Create raw database
CREATE DATABASE IF NOT EXISTS HBP_RAW;

-- Create analytics database
CREATE DATABASE IF NOT EXISTS HBP_ANALYTICS;

-- Create schemas in HBP_RAW
CREATE SCHEMA IF NOT EXISTS HBP_RAW.INGEST;

-- Create schemas in HBP_ANALYTICS
CREATE SCHEMA IF NOT EXISTS HBP_ANALYTICS.STAGING;
CREATE SCHEMA IF NOT EXISTS HBP_ANALYTICS.INTERMEDIATE;
CREATE SCHEMA IF NOT EXISTS HBP_ANALYTICS.MARTS;

