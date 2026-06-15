import pandas as pd
import sys


def load_csv(filepath):
    """Load orders CSV."""
    return pd.read_csv(filepath, dtype=str)


def validate_orders(df):
    """Validate order data."""

    if df['order_id'].isnull().any():
        raise ValueError("Null order_id values found.")

    if df['order_id'].duplicated().any():
        raise ValueError("Duplicate order_id values found.")

    if df['customer_id'].isnull().any():
        raise ValueError("Null customer_id values found.")

    if (df['quantity'].astype(int) <= 0).any():
        raise ValueError("Quantity must be greater than zero.")

    if (df['unit_price_pence'].astype(int) <= 0).any():
        raise ValueError(
            "Unit price must be greater than zero."
        )

    valid_status = {
        'completed',
        'pending',
        'cancelled',
        'refunded'
    }

    invalid = ~df['status'].str.lower().isin(valid_status)

    if invalid.any():
        raise ValueError("Invalid order status values.")


def transform_orders(df):
    """Transform order data."""

    df['order_id'] = df['order_id'].astype(int)

    df['customer_id'] = df['customer_id'].astype(int)

    df['quantity'] = df['quantity'].astype(int)

    df['unit_price_pence'] = (
        df['unit_price_pence']
        .astype(int)
    )

    df['status'] = (
        df['status']
        .str.lower()
        .str.strip()
    )

    df['ordered_at'] = pd.to_datetime(
        df['ordered_at']
    ).dt.date

    return df


def save_to_processed(df, filepath):
    """Save cleaned orders."""
    df.to_csv(filepath, index=False)


def main():

    try:
        df = load_csv('data/raw/orders.csv')

        validate_orders(df)

        df = transform_orders(df)

        save_to_processed(
            df,
            'data/processed/orders_clean.csv'
        )

        print("Orders ingestion completed.")

    except Exception as e:
        print(e)
        sys.exit(1)


if __name__ == "__main__":
    main()