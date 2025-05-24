USE superstore_etl;

SET QUOTED_IDENTIFIER ON;

-- Add columns
IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('dbo.product_dim')
    AND name = 'total_revenue'
)
BEGIN 
    ALTER TABLE dbo.product_dim 
    ADD total_revenue DECIMAL(10, 2) DEFAULT 0.0; 
END; 

-- product order count 
IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('dbo.product_dim')
    AND name = 'order_count'
)
BEGIN 
    ALTER TABLE dbo.product_dim 
    ADD order_count INT DEFAULT 0; 
END; 


-- product discount frequency 
IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('dbo.product_dim')
    AND name = 'discount_frequency'
)
BEGIN 
    ALTER TABLE dbo.product_dim 
    ADD discount_frequency INT DEFAULT 0; 
END; 


-- total discount amount 
IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('dbo.product_dim')
    AND name = 'discount_amount'
)
BEGIN 
    ALTER TABLE dbo.product_dim 
    ADD discount_amount DECIMAL(10, 2) DEFAULT 0.0; 
END; 


-- customer count 
IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('dbo.product_dim')
    AND name = 'no_of_customers'
)
BEGIN 
    ALTER TABLE dbo.product_dim 
    ADD no_of_customers INT DEFAULT 0; 
END; 


-- return count 
IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('dbo.product_dim')
    AND name = 'return_count'
)
BEGIN 
    ALTER TABLE dbo.product_dim 
    ADD return_count INT DEFAULT 0; 
END; 

-- return revenue 
IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('dbo.product_dim')
    AND name = 'return_revenue'
)
BEGIN 
    ALTER TABLE dbo.product_dim 
    ADD return_revenue DECIMAL(10, 2) DEFAULT 0.0; 
END; 

-- Update the table
UPDATE pd
SET 
    total_revenue = o.total_revenue, 
    order_count = o.order_count, 
    discount_frequency = o.discount_frequency,
    discount_amount = o.discount_amount,
    no_of_customers = o.no_of_customers, 
    return_count = o.return_count, 
    return_revenue = o.return_revenue
FROM dbo.product_dim pd
JOIN(
    SELECT
        product_id, 
        SUM(total_price) AS total_revenue, 
        COUNT(DISTINCT order_id) AS order_count, 
        SUM(CASE WHEN discount > 0 THEN 1 ELSE 0 END) AS discount_frequency, 
        SUM(discount_amount) AS discount_amount, 
        COUNT(DISTINCT customer_id) AS no_of_customers, 
        SUM(CAST(is_return AS INT)) AS return_count, 
        SUM(CASE WHEN is_return = 1 THEN total_price ELSE 0 END) AS return_revenue
    FROM dbo.orders_facts
    GROUP BY product_id
) o ON o.product_id = pd.product_id

SELECT * FROM product_dim ORDER BY no_of_customers DESC;