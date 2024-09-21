CREATE OR REPLACE VIEW stg_02_view_orders AS
WITH ingestion AS (
  SELECT
    invoice_and_item_number AS id,
    date,
    store_number AS store_id,
    store_name,
    address,
    city,
    zip_code,
    store_location,
    county_number AS county_id,
    county AS county_name,
    category AS category_id,
    category_name,
    vendor_number AS vendor_id,
    vendor_name,
    item_number AS item_id,
    item_description,
    pack,
    bottle_volume_ml,
    state_bottle_cost AS wholesale_cost,
    state_bottle_retail AS selling_price,
    bottles_sold,
    sale_dollars,
    volume_sold_liters,
    volume_sold_gallons
  FROM `lunar-spring-434419-q4.Analytics.yalo`
),
cleaning AS (
  SELECT 
    id,
    date,
    store_id,
    COALESCE(store_name, 'Unknown') AS store_name,
    address,
    city,
    zip_code,
    store_location,
    county_id,
    county_name,
    SAFE_CAST(category_id AS INT) AS category_id,
    category_name,
    vendor_id,
    vendor_name,
    item_id,
    pack,
    bottle_volume_ml,
    wholesale_cost,
    selling_price,
    ROUND(selling_price - wholesale_cost, 2) AS profit_margin,
    bottles_sold,
    sale_dollars,
    volume_sold_liters,
    volume_sold_gallons
  FROM ingestion
  WHERE (sale_dollars > 0 AND sale_dollars IS NOT NULL)
    OR bottles_sold > 0 
)
SELECT *
FROM cleaning;
