"""
=========================================================
File: ingest_capstone.py

Purpose:
    Ingest, validate, transform and save HBP support
    ticket data.

Pattern:
    load_csv()
    validate_support_tickets()
    transform_support_tickets()
    save_to_processed()

Output:
    processed/support_tickets_clean.csv

Author: Tony Blair
=========================================================
"""

import sys
import re
from pathlib import Path

import pandas as pd


# -------------------------------------------------------
# File paths
# -------------------------------------------------------

RAW_FILE = Path("data/raw/capstone_support_tickets.csv")

OUTPUT_FILE = Path(
    "data/processed/support_tickets_clean.csv"
)


# -------------------------------------------------------
# Function 1
# -------------------------------------------------------

def load_csv(file_path: Path) -> pd.DataFrame:
    """
    Load support ticket CSV into a DataFrame.

    Args:
        file_path (Path):
            Location of the raw CSV.

    Returns:
        pd.DataFrame:
            Loaded support ticket data.
    """

    return pd.read_csv(file_path)


# -------------------------------------------------------
# Function 2
# -------------------------------------------------------

def validate_support_tickets(df: pd.DataFrame) -> None:
    """
    Validate support ticket data.

    Validation Rules:
        - ticket_id must not be null
        - ticket_id must be unique
        - ticket_id must match T001 format
        - customer_id must not be null
        - status must be valid
        - priority must be valid
        - category must be valid
        - resolved_at cannot be earlier than created_at

    Raises:
        ValueError if validation fails.
    """

    # -------------------------------
    # Null ticket_id check
    # -------------------------------

    if df["ticket_id"].isnull().any():
        raise ValueError(
            "Validation failed: NULL ticket_id found."
        )

    # -------------------------------
    # Duplicate ticket_id check
    # -------------------------------

    if df["ticket_id"].duplicated().any():
        raise ValueError(
            "Validation failed: Duplicate ticket_id found."
        )

    # -------------------------------
    # Ticket format check
    # Expected: T001, T002, etc.
    # -------------------------------

    pattern = r"^T\d{3}$"

    invalid_ticket_ids = df[
        ~df["ticket_id"].astype(str).str.match(pattern)
    ]

    if not invalid_ticket_ids.empty:
        raise ValueError(
            "Validation failed: Invalid ticket_id format."
        )

    # -------------------------------
    # customer_id check
    # -------------------------------

    if df["customer_id"].isnull().any():
        raise ValueError(
            "Validation failed: NULL customer_id found."
        )

    # -------------------------------
    # Valid status check
    # -------------------------------

    valid_statuses = {
        "open",
        "resolved",
        "closed"
    }

    invalid_statuses = df[
        ~df["status"]
        .str.lower()
        .isin(valid_statuses)
    ]

    if not invalid_statuses.empty:
        raise ValueError(
            "Validation failed: Invalid status value."
        )

    # -------------------------------
    # Valid priority check
    # -------------------------------

    valid_priorities = {
        "high",
        "medium",
        "low"
    }

    invalid_priorities = df[
        ~df["priority"]
        .str.lower()
        .isin(valid_priorities)
    ]

    if not invalid_priorities.empty:
        raise ValueError(
            "Validation failed: Invalid priority value."
        )

    # -------------------------------
    # Valid category check
    # -------------------------------

    valid_categories = {
        "billing",
        "delivery",
        "product",
        "account"
    }

    invalid_categories = df[
        ~df["category"]
        .str.lower()
        .isin(valid_categories)
    ]

    if not invalid_categories.empty:
        raise ValueError(
            "Validation failed: Invalid category."
        )

    # -------------------------------
    # Date validation
    # -------------------------------

    created_dates = pd.to_datetime(
        df["created_at"],
        format="%d/%m/%Y",
        errors="coerce"
    )

    resolved_dates = pd.to_datetime(
        df["resolved_at"],
        format="%d/%m/%Y",
        errors="coerce"
    )

    invalid_dates = (
        resolved_dates.notna()
        & (resolved_dates < created_dates)
    )

    if invalid_dates.any():
        raise ValueError(
            "Validation failed: resolved_at "
            "earlier than created_at."
        )

    print("Validation passed.")


# -------------------------------------------------------
# Function 3
# -------------------------------------------------------

def transform_support_tickets(
    df: pd.DataFrame
) -> pd.DataFrame:
    """
    Apply cleaning and transformation logic.

    Transformations:
        - Strip whitespace
        - Standardize text
        - Convert customer_id to integer
        - Parse dates
        - Calculate days_to_resolve

    Returns:
        Cleaned DataFrame.
    """

    transformed = df.copy()

    # -------------------------------
    # Ticket ID
    # -------------------------------

    transformed["ticket_id"] = (
        transformed["ticket_id"]
        .astype(str)
        .str.strip()
        .str.upper()
    )

    # -------------------------------
    # Customer ID
    # -------------------------------

    transformed["customer_id"] = (
        transformed["customer_id"]
        .astype(int)
    )

    # -------------------------------
    # Subject
    # -------------------------------

    transformed["subject"] = (
        transformed["subject"]
        .astype(str)
        .str.strip()
    )

    # -------------------------------
    # Category
    # -------------------------------

    transformed["category"] = (
        transformed["category"]
        .astype(str)
        .str.strip()
        .str.title()
    )

    # -------------------------------
    # Priority
    # -------------------------------

    transformed["priority"] = (
        transformed["priority"]
        .astype(str)
        .str.strip()
        .str.lower()
    )

    # -------------------------------
    # Status
    # -------------------------------

    transformed["status"] = (
        transformed["status"]
        .astype(str)
        .str.strip()
        .str.lower()
    )

    # -------------------------------
    # Agent name
    # -------------------------------

    transformed["agent_name"] = (
        transformed["agent_name"]
        .astype(str)
        .str.strip()
    )

    # -------------------------------
    # Created date
    # -------------------------------

    transformed["created_at"] = pd.to_datetime(
        transformed["created_at"],
        format="%d/%m/%Y"
    )

    # -------------------------------
    # Resolved date
    # Allow NULL values
    # -------------------------------

    transformed["resolved_at"] = pd.to_datetime(
        transformed["resolved_at"],
        format="%d/%m/%Y",
        errors="coerce"
    )

    # -------------------------------
    # Days to resolve
    # Open tickets remain NULL
    # -------------------------------

    transformed["days_to_resolve"] = (
        transformed["resolved_at"]
        - transformed["created_at"]
    ).dt.days

    print("Transformation completed.")

    return transformed


# -------------------------------------------------------
# Function 4
# -------------------------------------------------------

def save_to_processed(
    df: pd.DataFrame,
    output_path: Path
) -> None:
    """
    Save cleaned data to processed layer.

    Args:
        df:
            Cleaned dataframe

        output_path:
            Destination CSV
    """

    output_path.parent.mkdir(
        parents=True,
        exist_ok=True
    )

    df.to_csv(
        output_path,
        index=False
    )

    print(
        f"Clean file saved to: {output_path}"
    )


# -------------------------------------------------------
# Main pipeline
# -------------------------------------------------------

def main() -> None:
    """
    Execute ingestion pipeline.
    """

    try:

        df = load_csv(RAW_FILE)

        validate_support_tickets(df)

        cleaned_df = (
            transform_support_tickets(df)
        )

        save_to_processed(
            cleaned_df,
            OUTPUT_FILE
        )

        print(
            "Support ticket pipeline completed."
        )

    except Exception as error:

        print(
            f"Pipeline failed: {error}"
        )

        sys.exit(1)


if __name__ == "__main__":
    main()