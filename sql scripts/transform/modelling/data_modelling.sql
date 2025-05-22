USE superstore_etl;

-- ##########################
-- FACT TABLE: orders_facts --
-- ##########################

-- Drop the fact table if it exists to recreate it fresh.
DROP TABLE IF EXISTS dbo.orders_facts;

SET QUOTED_IDENTIFIER ON;

CREATE TABLE orders_facts (
    order_fact_key INT IDENTITY(1,1) PRIMARY KEY,  -- surrogate key
    order_id VARCHAR(50) NOT NULL, 
    customer_id INT NOT NULL, 
    product_id INT NOT NULL, 
    region_id INT, 
    ship_mode_id INT, 
    order_date DATE, 
    ship_date DATE, 
    discount DECIMAL(5,2), 
    unit_price DECIMAL(10,2), 
    discount_amount DECIMAL(10,2),
    discount_price DECIMAL(10,2),
    shipping_cost DECIMAL(10,2), 
    quantity INT, 
    total_price AS (discount_price * quantity) PERSISTED, 
    is_return BIT
);
