SELECT 
    county
FROM `bigquery-public-data.iowa_liquor_sales.sales`
where sale_dollars > 100000
GROUP BY 1
ORDER BY 1 DESC;
