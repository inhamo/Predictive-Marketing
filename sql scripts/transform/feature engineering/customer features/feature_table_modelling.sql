USE superstore_etl;

SET QUOTED_IDENTIFIER ON;

-- Drop existing feature table to refresh it
DROP TABLE IF EXISTS dbo.customer_features;

-- Create a new customer_features table with proper data types and constraints
CREATE TABLE dbo.customer_features (
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
    customer_first_order_product_count INT,
    customer_first_order_value DECIMAL(10, 2),
    customer_recency INT, 
    customer_shipment_costs DECIMAL(10, 2)
);

-- First insert basic aggregated metrics
WITH customer_metrics AS (
    SELECT 
        c.customer_id,
        MIN(o.order_date) AS first_date,
        MAX(o.order_date) AS last_date,
        COUNT(DISTINCT o.order_id) AS order_count,
        SUM(o.quantity) AS total_quantity,
        SUM(o.total_price) AS total_revenue,
        SUM(CASE WHEN p.product_category = 'Returns' THEN 1 ELSE 0 END) AS return_count,
        SUM(CASE WHEN p.product_category = 'Returns' THEN o.total_price ELSE 0 END) AS return_value,
        DATEDIFF(DAY, MAX(o.order_date), (SELECT MAX(order_date) FROM dbo.orders_facts)) AS recency,
        SUM(o.shipping_cost) AS shipment_costs
    FROM dbo.customer_dim c
    JOIN dbo.orders_facts o ON c.customer_id = o.customer_id
    JOIN dbo.product_dim p ON o.product_id = p.product_id
    GROUP BY c.customer_id
),
first_order_stats AS (
    SELECT 
        o.customer_id,
        COUNT(*) AS first_order_product_count,
        SUM(o.total_price) AS first_order_value
    FROM dbo.orders_facts o
    INNER JOIN (
        SELECT customer_id, MIN(order_date) AS first_order_date
        FROM dbo.orders_facts
        GROUP BY customer_id
    ) fo ON o.customer_id = fo.customer_id AND o.order_date = fo.first_order_date
    GROUP BY o.customer_id
)

INSERT INTO dbo.customer_features
SELECT 
    cm.customer_id,
    cm.first_date AS customer_first_date,
    cm.last_date AS customer_last_date,
    DATEDIFF(DAY, cm.first_date, cm.last_date) AS customer_tenure,
    cm.order_count AS customer_no_of_orders,
    cm.total_quantity AS customer_total_quantity,
    CASE WHEN cm.order_count > 0 THEN cm.total_revenue / cm.order_count ELSE 0 END AS customer_average_order_value,
    cm.total_revenue AS customer_historical_clv, -- Basic CLV is total revenue for now
    0.0 AS customer_diversity_score, -- Will update in subsequent steps
    cm.total_revenue AS customer_total_revenue,
    CASE WHEN cm.order_count > 1 THEN 1 ELSE 0 END AS customer_is_repeat,
    0.0 AS customer_churn_probability, -- Will calculate later
    NULL AS customer_avg_days_between_orders, -- Will calculate later
    cm.return_count AS customer_return_count,
    cm.return_value AS customer_return_value,
    fos.first_order_product_count AS customer_first_order_product_count,
    fos.first_order_value AS customer_first_order_value,
    cm.recency AS customer_recency,
    cm.shipment_costs AS customer_shipment_costs
FROM customer_metrics cm
LEFT JOIN first_order_stats fos ON cm.customer_id = fos.customer_id;