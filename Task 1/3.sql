WITH RankedStores AS (
    SELECT 
        store_name,
        SUM(sale_dollars) AS total_revenue,
        DENSE_RANK() OVER (ORDER BY SUM(sale_dollars) DESC) AS rank_desc,
        DENSE_RANK() OVER (ORDER BY SUM(sale_dollars) ASC) AS rank_asc
    FROM `bigquery-public-data.iowa_liquor_sales.sales`
    GROUP BY 1
)
SELECT store_name FROM RankedStores
WHERE rank_desc <= 10 OR rank_asc <= 10
Order by rank_desc;