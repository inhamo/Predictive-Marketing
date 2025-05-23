USE superstore_etl;

SET QUOTED_IDENTIFIER ON; 

-- Add columns if they don't exist
IF NOT EXISTS (SELECT 1 FROM sys.columns 
               WHERE object_id = OBJECT_ID('dbo.region_dim') 
               AND name = 'total_revenue')
BEGIN
    ALTER TABLE dbo.region_dim
    ADD total_revenue DECIMAL(10, 2) DEFAULT 0;
END;

IF NOT EXISTS (SELECT 1 FROM sys.columns
              WHERE object_id = OBJECT_ID('dbo.region_dim')
              AND name = 'total_customers')
BEGIN 
    ALTER TABLE dbo.region_dim 
    ADD total_customers INT DEFAULT 0;
END;

IF NOT EXISTS (SELECT 1 FROM sys.columns
              WHERE object_id = OBJECT_ID('dbo.region_dim')
              AND name = 'revenue_per_customer') 
BEGIN
    ALTER TABLE dbo.region_dim 
    ADD revenue_per_customer DECIMAL(10, 2) DEFAULT 0;
END;

IF NOT EXISTS (SELECT 1 FROM sys.columns
              WHERE object_id = OBJECT_ID('dbo.region_dim')
              AND name = 'total_orders') 
BEGIN 
    ALTER TABLE dbo.region_dim 
    ADD total_orders INT DEFAULT 0;
END;

IF NOT EXISTS (SELECT 1 FROM sys.columns
              WHERE object_id = OBJECT_ID('dbo.region_dim')
              AND name = 'avg_order_value')
BEGIN 
    ALTER TABLE dbo.region_dim 
    ADD avg_order_value DECIMAL(10, 2) DEFAULT 0;
END;

IF NOT EXISTS (SELECT 1 FROM sys.columns
              WHERE object_id = OBJECT_ID('dbo.region_dim')
              AND name = 'return_rate')
BEGIN 
    ALTER TABLE dbo.region_dim 
    ADD return_rate DECIMAL(10, 2) DEFAULT 0;
END;

-- Update all metrics using a comprehensive CTE
WITH region_stats AS (
    SELECT
        o.region_id,
        SUM(o.total_price) AS total_revenue,
        COUNT(DISTINCT o.customer_id) AS customer_count,
        COUNT(DISTINCT o.order_id) AS order_count,
        CASE 
            WHEN COUNT(DISTINCT o.order_id) > 0 
            THEN SUM(o.total_price) / COUNT(DISTINCT o.order_id) 
            ELSE 0 
        END AS avg_order_value,
        CASE
            WHEN COUNT(DISTINCT o.order_id) > 0
            THEN SUM(CASE WHEN o.is_return = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT o.order_id)
            ELSE 0
        END AS return_rate
    FROM dbo.orders_facts o
    GROUP BY o.region_id
)
UPDATE rd
SET 
    total_revenue = rs.total_revenue,
    total_customers = rs.customer_count,
    revenue_per_customer = CASE 
                            WHEN rs.customer_count > 0 
                            THEN rs.total_revenue / rs.customer_count 
                            ELSE 0 
                          END,
    total_orders = rs.order_count,
    avg_order_value = rs.avg_order_value,
    return_rate = rs.return_rate
FROM dbo.region_dim rd
JOIN region_stats rs ON rs.region_id = rd.region_id;

