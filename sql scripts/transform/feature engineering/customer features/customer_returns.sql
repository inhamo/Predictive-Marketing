USE superstore_etl;

-- Update is_return based on customer_returns
UPDATE o
SET is_return = COALESCE(c.return_status, 0)
FROM dbo.orders_facts o
LEFT JOIN (
    SELECT 
        order_id,
        CASE WHEN status = 'Returned' THEN 1 ELSE 0 END AS return_status
    FROM dbo.customer_returns
) c ON c.order_id = o.order_id;

-- Now update no. of returns in the facts table 
WITH order_level AS (
    SELECT DISTINCT
        customer_id,
        order_id,
        is_return,
        total_price AS order_total_price
    FROM dbo.orders_facts
    WHERE is_return = 1 
),
return_summary AS (
    SELECT 
        customer_id,
        COUNT(*) AS return_count,
        SUM(order_total_price) AS return_value
    FROM order_level
    GROUP BY customer_id
)
UPDATE cf
SET customer_return_count = c.return_count, customer_return_value = c.return_value
FROM dbo.customer_features cf
JOIN return_summary c ON c.customer_id = cf.customer_id;


