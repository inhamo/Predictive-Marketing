-- CHECKING FOR NULL VALUES IN CRUCIAL COLUMNS 
SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS missing_customer_id,
  SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS missing_order_id,
  SUM(CASE WHEN customer_name IS NULL THEN 1 ELSE 0 END) AS misssing_customer_name,
  SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END) AS missing_regions, 
  SUM(CASE WHEN state_or_province IS NULL THEN 1 ELSE 0 END) AS missing_state_or_province, 
  SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS missing_city, 
  SUM(CASE WHEN postal_code IS NULL THEN 1 ELSE 0 END) AS missing_postal_code, 
  SUM(CASE WHEN customer_segment IS NULL THEN 1 ELSE 0 END) AS missing_customer_segment, 
  SUM(CASE WHEN order_priority IS NULL THEN 1 ELSE 0 END) AS missing_order_priority, 
  SUM(CASE WHEN ship_mode IS NULL THEN 1 ELSE 0 END) AS missing_ship_mode, 
  SUM(CASE WHEN product_category IS NULL THEN 1 ELSE 0 END) AS missing_product_category, 
  SUM(CASE WHEN product_sub_category IS NULL THEN 1 ELSE 0 END) AS missing_sub_category, 
  SUM(CASE WHEN product_container IS NULL THEN 1 ELSE 0 END) AS missing_container, 
  SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END) AS missing_product_name, 
  SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS missing_order_date, 
  SUM(CASE WHEN ship_date IS NULL THEN 1 ELSE 0 END) AS missing_ship_date, 
  SUM(CASE WHEN discount IS NULL THEN 1 ELSE 0 END) AS missing_discount, 
  SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS missing_unit_price,
  SUM(CASE WHEN discount_amount IS NULL THEN 1 ELSE 0 END) AS missing_discount_amount,
  SUM(CASE WHEN discount_price IS NULL THEN 1 ELSE 0 END) AS missing_discounted_price, 
  SUM(CASE WHEN shipping_cost IS NULL THEN 1 ELSE 0 END) AS missing_shipping_cost, 
  SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS missing_quantity
FROM superstore_etl.dbo.staging_orders;


-- HANDLE DUPLICATES
WITH Duplicates AS (
  SELECT  *, 
    ROW_NUMBER() OVER (
      PARTITION BY order_id, customer_id, product_name
      ORDER BY (SELECT NULL)
    ) AS rn
  FROM superstore_etl.dbo.staging_orders
)
DELETE Duplicates
WHERE rn > 1;

