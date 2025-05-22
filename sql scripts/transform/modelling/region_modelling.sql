USE superstore_etl;

-- Drop the product dimension table if it exists
DROP TABLE IF EXISTS region_dim;

CREATE TABLE region_dim (
    region_id INT IDENTITY(1,1) PRIMARY KEY, 
    region VARCHAR(50), 
    state_or_province VARCHAR(50), 
    city VARCHAR(50), 
    postal_code VARCHAR(10)
);
INSERT INTO region_dim 
SELECT DISTINCT 
    region, 
    state_or_province, 
    city, 
    postal_code
FROM dbo.staging_orders;

