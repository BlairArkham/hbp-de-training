import subprocess
import sys


def run_script(script_name):
    """
    Execute an ingestion script.

    Stops pipeline execution if a script fails.
    """

    print(f"\nRunning {script_name}...")

    result = subprocess.run(
        ['python', script_name]
    )

    if result.returncode != 0:

        print(
            f"{script_name} failed."
        )

        sys.exit(1)

    print(
        f"{script_name} completed."
    )


def main():
    """Run all ingestion pipelines."""

    scripts = [
        'ingestion/ingest_customers.py',
        'ingestion/ingest_orders.py',
        'ingestion/ingest_products.py'
    ]

    for script in scripts:
        run_script(script)

    print(
        "\nPipeline completed successfully."
    )


if __name__ == "__main__":
    main()