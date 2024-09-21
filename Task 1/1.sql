SELECT 
    EXTRACT(YEAR FROM date) AS year,
    EXTRACT(QUARTER FROM date) AS quarter,
    SUM(bottles_sold) AS total_products_sold,
    SUM(sale_dollars) AS total_revenue
FROM `bigquery-public-data.iowa_liquor_sales.sales`
GROUP BY 1,2
ORDER BY 1,2;

WITH monthly_revenue AS (
SELECT 
    EXTRACT(YEAR FROM date) AS year,
    EXTRACT(MONTH FROM date) AS month,
    SUM(sale_dollars) AS total_revenue
FROM `bigquery-public-data.iowa_liquor_sales.sales`
GROUP BY 1,2
),
average_monthly_revenue AS (
SELECT 
    AVG(total_revenue) AS avg_revenue
FROM monthly_revenue
)
SELECT 
    mr.year,
    mr.month,
    mr.total_revenue,
    ar.avg_revenue
FROM monthly_revenue mr,
    average_monthly_revenue ar
WHERE mr.total_revenue > ar.avg_revenue * 1.10
ORDER BY mr.year, mr.month;
