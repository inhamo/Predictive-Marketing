import subprocess
from pathlib import Path 
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

scripts = [
    # Schema setup and configuration
    "..\\sql scripts\\transform\\modelling\\data_cleaning.sql",
        
    # Dimension tables first
    "..\\sql scripts\\transform\\modelling\\customer_modelling.sql",
    "..\\sql scripts\\transform\\modelling\\product_modelling.sql",
    "..\\sql scripts\\transform\\modelling\\region_modelling.sql",
    "..\\sql scripts\\transform\\modelling\\ship_mode_dim.sql",
    
    # Fact tables
    "..\\sql scripts\\transform\\modelling\\populate_order_facts.sql",
    
    # Feature engineering (depends on facts and dimensions)
    "..\\sql scripts\\transform\\feature engineering\\customer features\\feature_table_modelling.sql",
    "..\\sql scripts\\transform\\feature engineering\\customer features\\customer_order_value.sql",
    "..\\sql scripts\\transform\\feature engineering\\customer features\\customer_first_order.sql",
    "..\\sql scripts\\transform\\feature engineering\\customer features\\customer_lifetime_value.sql",
    "..\\sql scripts\\transform\\feature engineering\\customer features\\customer_order_days.sql"
]

for script in scripts:
    print(f"Executing {script}...")
    result = subprocess.run([
        "sqlcmd",
        "-S", "DESKTOP-2ETDICD",
        "-d", "superstore_etl",
        "-U", os.getenv('DB_USER'),
        "-P", os.getenv('DB_PASSWORD'),
        "-i", str(Path("scripts") / script)
    ])
    if result.returncode != 0:
        print(f"Error executing {script}")
        exit(1)