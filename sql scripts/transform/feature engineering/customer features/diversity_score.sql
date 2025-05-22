USE superstore_etl;

WITH furniture_sales AS (
    SELECT 
        o.customer_id, 
        SUM(o.total_price) AS furniture_value
    FROM dbo.orders_facts o
    JOIN product_dim p ON p.product_id = o.product_id
    WHERE p.product_category = 'Furniture'
    GROUP BY o.customer_id
), 
tech_sales AS (
    SELECT 
        o.customer_id, 
        SUM(o.total_price) AS tech_value
    FROM dbo.orders_facts o
    JOIN product_dim p ON p.product_id = o.product_id
    WHERE p.product_category = 'Technology'
    GROUP BY o.customer_id
),
office_sales AS (
    SELECT 
        o.customer_id, 
        SUM(o.total_price) AS office_value
    FROM dbo.orders_facts o
    JOIN product_dim p ON p.product_id = o.product_id
    WHERE p.product_category = 'Office Supplies'
    GROUP BY o.customer_id
)
UPDATE dbo.customer_features
SET customer_diversity_score = div.diversity_score 
FROM dbo.customer_features cf
JOIN (
    SELECT 
        d.customer_id, 
        COALESCE(fs.furniture_value, 0) AS furniture_value, 
        COALESCE(t.tech_value, 0) AS tech_value, 
        COALESCE(f.office_value, 0) AS office_value,

        -- Total spend
        (COALESCE(fs.furniture_value, 0) + COALESCE(t.tech_value, 0) + COALESCE(f.office_value, 0)) AS total_value,

        -- Normalized HHI (0 to 1)
        (
            POWER(COALESCE(fs.furniture_value, 0) / NULLIF((COALESCE(fs.furniture_value, 0) + COALESCE(t.tech_value, 0) + COALESCE(f.office_value, 0)), 0), 2) +
            POWER(COALESCE(t.tech_value, 0) / NULLIF((COALESCE(fs.furniture_value, 0) + COALESCE(t.tech_value, 0) + COALESCE(f.office_value, 0)), 0), 2) +
            POWER(COALESCE(f.office_value, 0) / NULLIF((COALESCE(fs.furniture_value, 0) + COALESCE(t.tech_value, 0) + COALESCE(f.office_value, 0)), 0), 2)
        ) AS hhi_score,

        -- Diversity Score (1 - HHI)
        (
            1 -
            (
                POWER(COALESCE(fs.furniture_value, 0) / NULLIF((COALESCE(fs.furniture_value, 0) + COALESCE(t.tech_value, 0) + COALESCE(f.office_value, 0)), 0), 2) +
                POWER(COALESCE(t.tech_value, 0) / NULLIF((COALESCE(fs.furniture_value, 0) + COALESCE(t.tech_value, 0) + COALESCE(f.office_value, 0)), 0), 2) +
                POWER(COALESCE(f.office_value, 0) / NULLIF((COALESCE(fs.furniture_value, 0) + COALESCE(t.tech_value, 0) + COALESCE(f.office_value, 0)), 0), 2)
            )
        ) AS diversity_score

    FROM dbo.customer_features d
    LEFT JOIN office_sales f ON f.customer_id = d.customer_id
    LEFT JOIN tech_sales t ON t.customer_id = d.customer_id
    LEFT JOIN furniture_sales fs ON fs.customer_id = d.customer_id
    -- Exclude customers with zero total sales
    WHERE (COALESCE(fs.furniture_value, 0) + COALESCE(t.tech_value, 0) + COALESCE(f.office_value, 0)) > 0
) div ON div.customer_id = cf.customer_id;



