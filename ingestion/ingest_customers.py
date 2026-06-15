import pandas as pd
import sys


def load_csv(filepath):
    """
    Load customer data from a CSV file.

    Args:
        filepath (str): Path to the raw customer CSV file.

    Returns:
        pd.DataFrame: Loaded customer data.
    """
    return pd.read_csv(filepath, dtype=str)


def validate_customers(df):
    """
    Validate customer data.

    Validation rules:
    - customer_id cannot be null
    - customer_id must be unique
    - email must contain '@'
    - is_active must be 'true' or 'false'

    Raises:
        ValueError: If validation fails.
    """

    if df['customer_id'].isnull().any():
        raise ValueError("Null customer_id values found.")

    if df['customer_id'].duplicated().any():
        raise ValueError("Duplicate customer_id values found.")

    invalid_emails = ~df['email'].str.contains('@', na=False)

    if invalid_emails.any():
        raise ValueError("Invalid email addresses found.")

    valid_status = {'true', 'false'}

    invalid_status = ~df['is_active'].str.lower().isin(valid_status)

    if invalid_status.any():
        raise ValueError(
            "is_active contains values other than true/false."
        )


def transform_customers(df):
    """
    Transform customer data.

    Returns:
        pd.DataFrame: Cleaned customer data.
    """

    df['customer_id'] = df['customer_id'].astype(int)

    df['first_name'] = df['first_name'].str.strip()

    df['last_name'] = df['last_name'].str.strip()

    df['email'] = df['email'].str.strip().str.lower()

    df['country'] = df['country'].str.strip().str.upper()

    df['created_at'] = pd.to_datetime(
        df['created_at']
    ).dt.date

    df['is_active'] = (
        df['is_active']
        .str.lower()
        .map({'true': True, 'false': False})
    )

    return df


def save_to_processed(df, filepath):
    """
    Save cleaned customer data.

    Args:
        df (pd.DataFrame): Cleaned data.
        filepath (str): Output file path.
    """
    df.to_csv(filepath, index=False)


def main():
    """
    Execute customer ingestion pipeline.
    """

    try:
        df = load_csv('data/raw/customers.csv')

        validate_customers(df)

        df = transform_customers(df)

        save_to_processed(
            df,
            'data/processed/customers_clean.csv'
        )

        print("Customer ingestion completed successfully.")

    except Exception as e:
        print(f"Customer ingestion failed: {e}")

        sys.exit(1)


if __name__ == "__main__":
    main()