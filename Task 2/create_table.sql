
CREATE TABLE FACT_SALES AS (
  SELECT 
    id, 
    date, 
    store_id, 
    county_id, 
    category_id, 
    vendor_id, 
    item_id, 
    wholesale_cost, 
    selling_price, 
    profit_margin, 
    bottles_sold, 
    sale_dollars
  FROM stg_02_view_orders
);


CREATE TABLE DIM_ITEM AS (
  SELECT 
    DISTINCT item_id, 
    item_description
  FROM stg_02_view_orders
);


CREATE TABLE DIM_CATEGORY AS (
  SELECT 
    DISTINCT category_id, 
    category_name
  FROM stg_02_view_orders
);


CREATE TABLE DIM_VENDOR AS (
  SELECT 
    DISTINCT vendor_id, 
    vendor_name
  FROM stg_02_view_orders
);


CREATE TABLE DIM_GEO AS (
  SELECT 
    DISTINCT county_id, 
    county_name, 
    city, 
    zip_code, 
    store_location
  FROM stg_02_view_orders
);


CREATE TABLE DIM_STORE AS (
  SELECT 
    DISTINCT store_id, 
    store_name, 
    address
  FROM stg_02_view_orders
);
