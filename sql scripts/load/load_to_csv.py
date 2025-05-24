import pandas as pd
import pyodbc

conn = pyodbc.connect(
    "DRIVER={SQL Server};" \
    "SERVER=DESKTOP-2ETDICD;" \
    "DATABASE=superstore_etl;" \
    "Trusted_Connection=yes;"
)

tables = pd.read_sql("SELECT table_name FROM information_schema.tables", conn)['table_name'].tolist()

for tb in tables:
    if tb == "staging_orders":
        continue
    
    df = pd.read_sql(f"SELECT * FROM dbo.{tb}", conn)
    df.to_csv(f"C:\\Users\\takue\\Documents\\Data Science\\Predictive Marketing\\final data\\{tb}.csv", index=False)
    print(f"{tb} successfully saved to final data")

