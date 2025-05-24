USE superstore_etl;

SET QUOTED_IDENTIFIER ON; 

-- Add columns if they don't exists 
IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('dbo.ship_mode_dim')
    AND name = 'total_revenue'
)
BEGIN 
    ALTER TABLE dbo.ship_mode_dim
    ADD total_revenue DECIMAL(10, 2) DEFAULT 0; 
END; 

-- Order count per shipment 
IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('dbo.ship_mode_dim')
    AND name = 'no_of_orders'
)
BEGIN 
    ALTER TABLE dbo.ship_mode_dim
    ADD no_of_orders DECIMAL(10, 2) DEFAULT 0; 
END;

-- total_shipping_cost
IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('dbo.ship_mode_dim')
    AND name = 'total_shipping_cost'
)
BEGIN 
    ALTER TABLE dbo.ship_mode_dim
    ADD total_shipping_cost DECIMAL(10, 2) DEFAULT 0; 
END;

-- Update the shipping table 
UPDATE sm
SET
    total_revenue = o.total_value, 
    no_of_orders = o.order_count, 
    total_shipping_cost = o.shipping_revenue
FROM dbo.ship_mode_dim sm
JOIN (
    SELECT 
        ship_mode_id,
        SUM(total_price) AS total_value ,
        SUM(shipping_cost) AS shipping_revenue,
        COUNT(DISTINCT order_id) AS order_count
    FROM dbo.orders_facts
    GROUP BY ship_mode_id
) o ON o.ship_mode_id = sm.ship_mode_id;

