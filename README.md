# HBP Data Engineering Training

## Overview

This repository contains my 10-day Data Engineering training project, covering the core concepts and tools used in a modern data stack. The work spans data modelling, SQL, Snowflake, Python-based ingestion, dbt transformations, Fivetran ingestion, cost management, documentation, and collaborative Git workflows.

The project culminates in an end-to-end capstone pipeline implementing the complete data lifecycle from raw ingestion to analytics-ready marts.

---

# Technology Stack

* **Snowflake** – Cloud data warehouse
* **dbt** – Data transformations and testing
* **Python** – Data ingestion and preprocessing
* **Pandas** – Data manipulation
* **Fivetran** – Managed data ingestion
* **Git & GitHub** – Version control and collaboration
* **dbdiagram.io** – Data modelling
* **Miro / Draw.io** – Architecture diagrams

---

# Project Structure

```text
hbp-de-training/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── ingestion/
│   ├── ingest_customers.py
│   ├── ingest_orders.py
│   ├── ingest_products.py
│   └── run_pipeline.py
│
├── sql/
│
├── models/
│   ├── staging/
│   ├── intermediate/
│   └── marts/
│
├── snapshots/
├── tests/
├── diagrams/
├── docs/
└── README.md
```

---

# HBP Data Lifecycle

The project follows a modern ELT architecture:

```text
Sources
   ↓
Ingestion
   ↓
Snowflake Warehouse
   ↓
dbt Transformations
   ↓
Intermediate Models
   ↓
Mart Models
   ↓
Analytics & Reporting
```

---

# Week 1

## Day 1 – Data Engineering Basics & Environment Setup

### Topics Covered

* Modern Data Engineering lifecycle
* ELT vs ETL
* GitHub repository setup
* Snowflake environment setup
* Architecture diagrams

### Deliverables

* Repository initialization
* Snowflake databases and warehouses
* HBP Data Lifecycle architecture

---

## Day 2 – Snowflake Querying & Intro to Workplace Tooling

### Topics Covered

* Creating databases and schemas
* Loading CSV files
* Exploratory SQL queries
* Pipeline architecture documentation

### Deliverables

* HBP_PRACTICE environment
* Data loading exercises
* HBP Pipeline Architecture

---

## Day 3 – Data Modelling: Normalisation & Schema Design

### Topics Covered

* 1NF, 2NF, 3NF
* Schema theory
* Fact and dimension tables
* Star schema design

### Deliverables

* Star schema models
* DDL scripts

---

## Day 4 – SQL for Data Engineering & Communication Skills

### Topics Covered

* SQL joins
* Aggregations
* HAVING clause
* CTEs
* Window functions introduction
* Professional communication

### Deliverables

* q1–q10 SQL exercises
* CTE vs subquery comparisons

---

## Day 5 – SQL Window Functions & Advanced Query Patterns

### Topics Covered

* ROW_NUMBER
* RANK and DENSE_RANK
* LAG and LEAD
* Running totals
* NTILE
* FIRST_VALUE and LAST_VALUE

### Deliverables

* q11–q17 SQL exercises
* Customer order history model
* Product metrics model
* Window function reference library

---

# Week 2

## Day 6 – Snowflake Cost Management & Communication Skills

### Topics Covered

* Python ingestion pipelines
* Data validation and transformation
* Snowflake Query History
* Query Profile
* Stakeholder communication

### Deliverables

* Modular ingestion scripts
* Pipeline orchestration
* Professional email and Slack communication

---

## Day 7 – Snowflake Advanced Features & dbt Setup

### Topics Covered

* COPY INTO
* Snowflake ingestion methods
* dbt setup
* Staging models
* Intermediate models
* Mart models
* dbt testing and documentation

### Deliverables

* Source → Staging → Intermediate → Mart pipeline
* dbt lineage DAG
* Data quality tests

---

## Day 8 – Fivetran, Legacy Migration & dbt Extension

### Topics Covered

* Fivetran connectors
* Snowflake integration
* dbt source configuration
* Legacy migration concepts
* Pipeline architecture updates

### Deliverables

* Automated ingestion pipeline
* Extended dbt models
* Updated architecture documentation

---

## Day 9 – Capstone: End-to-End Data Engineering Task

### Topics Covered

* Building a complete ELT pipeline
* Layered dbt architecture
* Data quality validation
* Documentation generation

### Deliverables

* Ingestion layer
* Staging layer
* Intermediate layer
* Mart layer
* dbt tests
* Documentation and lineage

---

## Day 10 – Capstone Final, Git Collaboration & Pipeline Pass

### Topics Covered

* Git collaboration workflows
* Pull requests and code reviews
* SQL documentation
* Metadata documentation
* Cost management
* Architecture updates

### Deliverables

* Repository cleanup
* Schema documentation
* Complete lineage DAG
* Updated HBP Data Lifecycle v3
* Cost profile analysis

---

# Known Data Quality Issues

The training dataset intentionally contained several quality issues to simulate real-world scenarios.

* Duplicate records
* Missing values
* Invalid email formats
* Inconsistent capitalization
* Invalid status values

Validation checks and dbt tests were implemented to detect and prevent these issues from propagating downstream.

---

# Cost Profile

The project uses Snowflake warehouses configured with auto-suspend enabled to minimize unnecessary compute costs.

Query History and Query Profile were used to monitor warehouse utilization and understand compute consumption during pipeline execution.

---

# Key Concepts Practiced

### Data Warehousing

* ELT architecture
* Snowflake warehouses
* Databases and schemas
* COPY INTO

### SQL

* Joins
* Aggregations
* CTEs
* Window functions
* Ranking
* Running totals

### Data Modelling

* Normalization
* Star schema design
* Fact and dimension tables

### Python

* Pandas
* Data validation
* Data transformations
* Pipeline orchestration

### dbt

* Sources
* Staging models
* Intermediate models
* Mart models
* Testing
* Documentation
* Lineage DAG

### Data Ingestion

* CSV ingestion
* Fivetran connectors
* Snowflake loading

### Software Engineering

* Git workflows
* Branching
* Pull requests
* Code reviews

### Professional Skills

* Stakeholder communication
* Slack etiquette
* Email communication
* Active listening
* Collaboration

---

# Final Outcome

By the end of this training, I built a complete modern data pipeline using industry-standard tools and practices. The project demonstrates the entire analytics engineering workflow—from ingestion and validation through transformation, testing, documentation, and delivery of analytics-ready datasets—while following software engineering best practices and collaborative development workflows.


The following diagram illustrates the HBP DataLifecycle

![Pipeline Architecture](data/raw/HBP%20Data%20Lifecycle.png)

## Known Data Quality Issues in the HBP Dataset

1. Missing values in customer email field
2. Empty fields on the created_at column
3. Inconsistent date formats across datasets
4. Null product prices in some rows
5. Incorrect status values (e.g., 'complete' vs 'completed')
