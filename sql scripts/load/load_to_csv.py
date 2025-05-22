import pandas as pd
import pyodbc

conn = pyodbc.connect(
    "DRIVER={SQL Server};" \
    "SERVER=DESKTOP-2ETDICD;" \
    "DATABASE=superstore_etl;" \
    "Trusted_Connection=yes;"
)

query = """ 
    SELECT * 
    FROM dbo.customer_features
"""

df = pd.read_sql(query, conn)
df.to_csv("customer_features.csv", index=False)
