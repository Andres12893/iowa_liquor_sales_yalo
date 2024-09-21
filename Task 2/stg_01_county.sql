UPDATE `lunar-spring-434419-q4.Analytics.yalo` t
SET t.county_number = non_null.county_number
FROM (
    SELECT county, MAX(county_number) AS county_number
    FROM `lunar-spring-434419-q4.Analytics.yalo`
    WHERE county_number IS NOT NULL
    GROUP BY county
) AS non_null
WHERE t.county_number IS NULL
AND t.county = non_null.county;
