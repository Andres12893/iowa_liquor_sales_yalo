CREATE TABLE test_orders (
    customer_id INT ,
    purchase_revenue DECIMAL(10, 2),
    purchase_date TIMESTAMP
);

CREATE TABLE test_order_details (
    order_id INT ,
    customer_id INT ,
    purchase_timestamp TIMESTAMP,
    number_items INT,
    purchase_price DECIMAL(10, 2),
    item_status VARCHAR(20)
);

INSERT INTO test_orders (customer_id, purchase_revenue, purchase_date)
VALUES
(1, 25.34, '2015-01-01 14:32:51'),
(2, 34.34, '2015-01-02 12:14:51'),
(3, 37.15, '2015-01-02 18:08:21'),
(2, 47.24, '2015-03-02 23:42:21'),
(2, 54.12, '2015-04-02 23:42:21'),
(3, 65.21, '2015-07-03 22:07:11'),
(1, 74.60, '2015-09-03 21:02:41'),
(3, 11.30, '2015-10-03 05:15:24'),
(2, 22.45, '2015-10-03 07:11:56');

INSERT INTO test_order_details (order_id, customer_id, purchase_timestamp, number_items, purchase_price, item_status)
VALUES
(1, 1, '2015-01-01 14:32:51', 2, 4.35, 'returned'),
(1, 1, '2015-01-01 14:32:51', 3, 8.446666667, 'sold'),
(1, 2, '2015-01-02 12:14:51', 1, 24, 'sold'),
(1, 2, '2015-01-02 12:14:51', 2, 5.17, 'sold'),
(1, 3, '2015-01-02 18:08:21', 3, 10, 'sold'),
(1, 3, '2015-01-02 18:08:21', 1, 7.15, 'sold'),
(2, 2, '2015-03-02 23:42:21', 2, 20, 'sold'),
(2, 2, '2015-03-02 23:42:21', 1, 7.24, 'returned'),
(2, 2, '2015-03-02 23:42:21', 1, 7.24, 'sold'),
(3, 2, '2015-04-02 23:42:21', 3, 18.04, 'sold'),
(2, 3, '2015-07-03 22:07:11', 2, 20, 'sold'),
(2, 3, '2015-07-03 22:07:11', 1, 25.21, 'sold'),
(2, 3, '2015-07-03 22:07:11', 4, 17.21, 'returned'),
(2, 1, '2015-09-03 21:02:41', 3, 10.2, 'sold'),
(2, 1, '2015-09-03 21:02:41', 2, 22, 'sold'),
(2, 1, '2015-09-03 21:02:41', 1, 15, 'returned'),
(3, 3, '2015-10-03 05:15:24', 1, 11.3, 'sold'),
(4, 2, '2015-10-03 07:11:56', 1, 22.45, 'sold');

--2
WITH grouped_sold_test_order_details AS (
SELECT
	customer_id,
	purchase_timestamp,
	SUM(number_items * purchase_price) as purchase_revenue
FROM test_order_details
WHERE item_status = 'sold'
GROUP BY 1,2)
SELECT 
	teo.customer_id,
	teo.purchase_date,
	teo.purchase_revenue,
	gtoe.purchase_revenue,
	(teo.purchase_revenue - gtoe.purchase_revenue) as revenue_difference
FROM grouped_sold_test_order_details gtoe
LEFT JOIN test_orders teo
ON teo.customer_id = gtoe.customer_id
AND teo.purchase_date = gtoe.purchase_timestamp;

--3
SELECT
	customer_id,
	purchase_timestamp,
	SUM(number_items * purchase_price) as original_revenue,
    SUM(CASE WHEN item_status = 'sold' THEN number_items * purchase_price ELSE 0 END) AS actual_revenue,
	SUM(number_items * purchase_price) - SUM(CASE WHEN item_status = 'sold' THEN number_items * purchase_price ELSE 0 END) AS additional_revenue,
	ROUND(100.0 * (SUM(number_items * purchase_price) - SUM(CASE WHEN item_status = 'sold' THEN number_items * purchase_price ELSE 0 END)) / 
          SUM(CASE WHEN item_status = 'sold' THEN number_items * purchase_price ELSE 0 END), 2) AS percentage_increase
FROM test_order_details
GROUP BY 1,2
ORDER BY 1,2

--4 
--Least: Customer 2, has the lowest percentage of returns and the lowest revenue lost due to a return.
--With respect to the largest, if the objective is to maximise the percentage of deliveries, then the most worrying is number 1,
--as it has 66% of returns, but if we want to maximise revenue, it would be number 3, as it is the one with which we lost the most.

--5
-- Add the order_id so that instead of joins by date, it is directly customer_id and order_id