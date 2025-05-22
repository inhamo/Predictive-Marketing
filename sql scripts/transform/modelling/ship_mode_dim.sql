USE superstore_etl; 

-- Drop the customer dimension table if it exists.
DROP TABLE IF EXISTS ship_mode_dim;

-- Create table
CREATE TABLE ship_mode_dim (
    ship_mode_id INT IDENTITY(1,1) PRIMARY KEY, 
    ship_mode VARCHAR(50)
);
INSERT INTO ship_mode_dim
SELECT DISTINCT
    ship_mode
FROM dbo.staging_orders;
