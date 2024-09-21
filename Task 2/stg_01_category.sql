UPDATE `lunar-spring-434419-q4.Analytics.yalo` t
SET t.category_name = non_null.category_name
FROM (
    SELECT category, MAX(category_name) AS category_name
    FROM `lunar-spring-434419-q4.Analytics.yalo`
    WHERE category_name IS NOT NULL
    GROUP BY category
) AS non_null
WHERE t.category_name IS NULL
AND t.category = non_null.category;
