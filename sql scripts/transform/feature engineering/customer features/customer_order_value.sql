USE superstore_etl;

SET QUOTED_IDENTIFIER ON;

WITH OrderValues AS (
    SELECT 
        customer_id, 
        order_id, 
        SUM(total_price) AS order_value
    FROM dbo.orders_facts
    GROUP BY customer_id, order_id
)
UPDATE cf
SET customer_average_order_value = ov.avg_order_value 
FROM customer_features cf
JOIN (
    SELECT 
        customer_id, 
        AVG(1.0 * order_value) AS avg_order_value
    FROM OrderValues
    GROUP BY customer_id
) ov ON cf.customer_id = ov.customer_id;

