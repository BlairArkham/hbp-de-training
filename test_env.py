from dotenv import load_dotenv
import os

load_dotenv()

print("User:", os.getenv("SNOWFLAKE_USER"))
print("Warehouse:", os.getenv("SNOWFLAKE_WAREHOUSE"))
print("Database:", os.getenv("SNOWFLAKE_DATABASE"))