USE superstore_etl;

SET QUOTED_IDENTIFIER ON;

-- Drop existing feature table to refresh it
DROP TABLE IF EXISTS dbo.customer_features;

-- Create a new customer_features table
CREATE TABLE customer_features (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_first_date DATE,
    customer_last_date DATE,
    customer_tenure INT,
    customer_no_of_orders INT,
    customer_total_quantity INT,
    customer_average_order_value DECIMAL(10, 2),
    customer_historical_clv DECIMAL(10, 2),
    customer_diversity_score DECIMAL(10, 2),
    customer_total_revenue DECIMAL(10, 2),
    customer_is_repeat BIT,
    customer_churn_probability FLOAT,
    customer_avg_days_between_orders FLOAT,
    customer_return_count INT,
    customer_return_value DECIMAL(10, 2),
    customer_avg_days_between_order_and_return FLOAT,
    customer_first_order_product_count INT,
    customer_first_order_value DECIMAL(10, 2),
    customer_recency INT
);

-- First insert basic aggregated metrics
INSERT INTO customer_features
SELECT 
    CAST(c.customer_id AS INT) AS customer_id,
    MIN(o.order_date) AS customer_first_date, 
    MAX(o.order_date) AS customer_last_date, 
    DATEDIFF(DAY, MIN(o.order_date), MAX(o.order_date)) AS customer_tenure,
    COUNT(DISTINCT o.order_id) AS customer_no_of_orders,
    SUM(o.quantity) AS customer_total_quantity,
    0.0 AS customer_average_order_value,
    0.0 AS customer_historical_clv, -- Will update later
    0.0 AS customer_diversity_score, -- Will update later
    SUM(o.total_price) AS customer_total_revenue,
    CASE WHEN COUNT(DISTINCT o.order_id) > 1 THEN 1 ELSE 0 END AS customer_is_repeat,
    0.0 AS customer_churn_probability,
    NULL AS customer_avg_days_between_orders,
    0 AS customer_return_count,
    0.0 AS customer_return_value,
    NULL AS customer_avg_days_between_order_and_return,
    NULL AS customer_first_order_product_count,
    NULL AS customer_first_order_value,
    DATEDIFF(DAY, MAX(o.order_date), (SELECT MAX(order_date) FROM dbo.orders_facts)) AS customer_recency
FROM dbo.customer_dim c
JOIN dbo.orders_facts o ON c.customer_id = o.customer_id
JOIN dbo.product_dim p ON o.product_id = p.product_id
GROUP BY c.customer_id;

