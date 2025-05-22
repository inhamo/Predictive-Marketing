USE superstore_etl; 

SET QUOTED_IDENTIFIER ON;

WITH FirstSales AS (
    SELECT 
        customer_id, 
        order_id,
        order_date,
        total_price,
        quantity,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS row_num
    FROM dbo.orders_facts
)
UPDATE cf 
SET customer_first_order_value = f.order_value, customer_first_order_product_count = f.quantity
FROM customer_features cf
JOIN 
    (SELECT 
        customer_id,
        order_id,
        quantity,
        total_price AS order_value
    FROM FirstSales
    WHERE row_num = 1) f ON f.customer_id = cf.customer_id;

