import pandas as pd
import sys


def load_csv(filepath):
    """Load products CSV."""
    return pd.read_csv(filepath, dtype=str)


def validate_products(df):
    """Validate product data."""

    if df['product_id'].isnull().any():
        raise ValueError("Null product_id found.")

    if df['product_id'].duplicated().any():
        raise ValueError(
            "Duplicate product_id values found."
        )

    if (
        df['unit_price_pence']
        .astype(int)
        <= 0
    ).any():
        raise ValueError(
            "Unit price must be positive."
        )

    valid_stock = {'true', 'false'}

    invalid = (
        ~df['in_stock']
        .str.lower()
        .isin(valid_stock)
    )

    if invalid.any():
        raise ValueError(
            "Invalid in_stock values."
        )


def transform_products(df):
    """Transform product data."""

    df['unit_price_pence'] = (
        df['unit_price_pence']
        .astype(int)
    )

    df['product_name'] = (
        df['product_name']
        .str.strip()
    )

    df['category'] = (
        df['category']
        .str.strip()
    )

    df['in_stock'] = (
        df['in_stock']
        .str.lower()
        .map({'true': True, 'false': False})
    )

    return df


def save_to_processed(df, filepath):
    """Save cleaned products."""
    df.to_csv(filepath, index=False)


def main():

    try:
        df = load_csv('data/raw/products.csv')

        validate_products(df)

        df = transform_products(df)

        save_to_processed(
            df,
            'data/processed/products_clean.csv'
        )

        print("Products ingestion completed.")

    except Exception as e:
        print(e)
        sys.exit(1)


if __name__ == "__main__":
    main()