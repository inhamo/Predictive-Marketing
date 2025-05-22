USE superstore_etl;

SET QUOTED_IDENTIFIER ON;

WITH OrderIntervals AS (
    SELECT 
        customer_id, 
        order_date,
        LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS next_order_date,
        DATEDIFF(DAY, order_date, LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) AS days_between_orders
    FROM dbo.orders_facts
)
UPDATE cf 
SET customer_avg_days_between_orders = o.avg_days_between_orders
FROM dbo.customer_features cf 
JOIN (
    SELECT 
        customer_id,
        AVG(days_between_orders) AS avg_days_between_orders
    FROM OrderIntervals
    WHERE days_between_orders IS NOT NULL
    GROUP BY customer_id
) o ON o.customer_id = cf.customer_id;

