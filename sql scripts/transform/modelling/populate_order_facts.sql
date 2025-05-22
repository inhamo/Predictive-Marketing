USE superstore_etl; 

SET QUOTED_IDENTIFIER ON;

INSERT INTO dbo.orders_facts (
    order_id, 
    customer_id,
    product_id, 
    region_id, 
    ship_mode_id,  
    order_date, 
    ship_date, 
    discount,
    unit_price, 
    discount_amount, 
    discount_price, 
    shipping_cost, 
    quantity,
    is_return
)
SELECT
    o.order_id, 
    o.customer_id,
    p.product_id, 
    r.region_id, 
    s.ship_mode_id,  
    o.order_date, 
    o.ship_date, 
    o.discount,
    o.unit_price, 
    o.discount_amount, 
    o.discount_price, 
    o.shipping_cost, 
    o.quantity,
    NULL
FROM dbo.staging_orders o
JOIN dbo.product_dim p 
  ON o.product_name = p.product_name 
 AND o.product_category = p.product_category
 AND o.product_sub_category = p.product_sub_category
 AND o.product_container = p.product_container
JOIN dbo.region_dim r 
  ON o.region = r.region 
 AND o.state_or_province = r.state_or_province 
 AND o.city = r.city 
 AND o.postal_code = r.postal_code
JOIN dbo.ship_mode_dim s 
  ON o.ship_mode = s.ship_mode;
