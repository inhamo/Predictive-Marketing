USE superstore_etl;
SET QUOTED_IDENTIFIER ON;

-- Add columns if they don't exist
IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.customer_features') AND name = 'discount_junkie_score')
BEGIN
    ALTER TABLE dbo.customer_features ADD discount_junkie_score FLOAT DEFAULT 0.0;
END;

IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.customer_features') AND name = 'avg_discount_rate')
BEGIN
    ALTER TABLE dbo.customer_features ADD avg_discount_rate FLOAT DEFAULT 0.0;
END;

IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.customer_features') AND name = 'discount_order_value_ratio')
BEGIN
    ALTER TABLE dbo.customer_features ADD discount_order_value_ratio FLOAT DEFAULT 0.0;
END;

IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.customer_features') AND name = 'non_discounted_order_count')
BEGIN
    ALTER TABLE dbo.customer_features ADD non_discounted_order_count INT DEFAULT 0;
END;

IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.customer_features') AND name = 'discount_threshold_behavior')
BEGIN
    ALTER TABLE dbo.customer_features ADD discount_threshold_behavior BIT DEFAULT 0;
END;

-- Update customer_features with metrics
WITH customer_metrics AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(CASE WHEN discount > 0 THEN 1 ELSE 0 END) * 1.0 / (COUNT(DISTINCT order_id) +  (SUM(CASE WHEN discount > 0 THEN 1 ELSE 0 END) * 1.0)) AS discount_junkie_score,
        AVG(discount) AS avg_discount_rate,
        SUM(CASE WHEN discount > 0 THEN total_price ELSE 0 END) * 1.0 / NULLIF(SUM(CASE WHEN discount = 0 THEN total_price ELSE 0 END), 0) AS discount_order_value_ratio,
        SUM(CASE WHEN discount = 0 THEN 1 ELSE 0 END) AS non_discounted_order_count,
        CASE WHEN MIN(discount) > 0.2 THEN 1 ELSE 0 END AS discount_threshold_behavior
    FROM dbo.orders_facts
    GROUP BY customer_id
)
UPDATE cf
SET
    cf.discount_junkie_score = ROUND(m.discount_junkie_score, 2),
    cf.avg_discount_rate = m.avg_discount_rate,
    cf.discount_order_value_ratio = ISNULL(m.discount_order_value_ratio, 0.0),
    cf.non_discounted_order_count = m.non_discounted_order_count,
    cf.discount_threshold_behavior = m.discount_threshold_behavior
FROM dbo.customer_features cf
JOIN customer_metrics m ON m.customer_id = cf.customer_id;

SELECT * FROM customer_features;