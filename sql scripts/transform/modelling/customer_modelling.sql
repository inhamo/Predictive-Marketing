USE superstore_etl;

DROP TABLE IF EXISTS dbo.customer_dim;

CREATE TABLE customer_dim (
    customer_key INT IDENTITY(1,1) PRIMARY KEY, 
    customer_id INT, 
    customer_name VARCHAR(50), 
    customer_segment VARCHAR(50), 
    start_date DATE,
    end_date DATE,
    is_current BIT
);

INSERT INTO customer_dim (
    customer_id, customer_name, customer_segment, start_date, end_date, is_current
)
SELECT 
    CAST(customer_id AS INT),
    customer_name,
    customer_segment,
    MIN(order_date),
    NULL,
    1
FROM dbo.staging_orders
GROUP BY CAST(customer_id AS INT), customer_name, customer_segment;

WITH SegmentOrder AS (
    SELECT 
        customer_key, 
        customer_id,
        start_date, 
        LEAD(start_date) OVER (PARTITION BY customer_id ORDER BY start_date) AS next_start_date
    FROM dbo.customer_dim
)
UPDATE cd
SET
    end_date = DATEADD(DAY, -1, so.next_start_date),
    is_current = 0
FROM dbo.customer_dim cd
JOIN SegmentOrder so ON cd.customer_key = so.customer_key
WHERE so.next_start_date IS NOT NULL;

WITH LatestSegment AS (
    SELECT 
        customer_key,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY start_date DESC) AS rn
    FROM dbo.customer_dim
)
UPDATE cd
SET
    end_date = NULL,
    is_current = 1
FROM dbo.customer_dim cd
JOIN LatestSegment ls ON cd.customer_key = ls.customer_key
WHERE ls.rn = 1;

ALTER TABLE dbo.customer_dim
ADD customer_group VARCHAR(5);

UPDATE dbo.customer_dim
SET customer_group = 
    CASE 
        WHEN customer_segment IN ('Corporate', 'Small Business') AND is_current = 1 THEN 'B2B'
        WHEN customer_segment IN ('Home Office', 'Consumer') AND is_current = 1 THEN 'B2C'
        ELSE NULL
    END;

