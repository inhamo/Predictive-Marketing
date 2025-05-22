USE superstore_etl; 

SET QUOTED_IDENTIFIER ON;

UPDATE cf
SET customer_historical_clv = clv.customer_lifetime_value
FROM dbo.customer_features cf
JOIN (
    SELECT 
        customer_id, 
        CASE 
            WHEN customer_tenure = 0 THEN 
                customer_average_order_value * customer_no_of_orders * 1.0 -- Assuming 1 year projection for new customers
            ELSE 
                customer_average_order_value * customer_no_of_orders * (customer_tenure / 365.0)
        END AS customer_lifetime_value
    FROM dbo.customer_features
) clv ON clv.customer_id = cf.customer_id;

SELECT * FROM dbo.customer_features ORDER BY customer_id;