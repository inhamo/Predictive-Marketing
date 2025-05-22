USE superstore_etl;

-- Drop the product dimension table if it exists
DROP TABLE IF EXISTS product_dim;

-- Create the product dimension table
CREATE TABLE product_dim (
    product_id INT IDENTITY(1,1) PRIMARY KEY,  
    product_name VARCHAR(200), 
    product_category VARCHAR(50), 
    product_sub_category VARCHAR(50), 
    product_container VARCHAR(50)
);

-- Populate the dimension with distinct product attributes
INSERT INTO product_dim (
    product_name, 
    product_category, 
    product_sub_category, 
    product_container
)
SELECT DISTINCT
    product_name, 
    product_category, 
    product_sub_category, 
    product_container
FROM dbo.staging_orders;

