--- 1. Create The Table 


-- Table Customers
CREATE TABLE customers(
  customer_id VARCHAR,
  customer_unique_id VARCHAR,
  customer_zip_code_prefix VARCHAR,
  customer_city VARCHAR,
  customer_state VARCHAR
);

-- Table Geolocation
CREATE TABLE geolocation(
  geolocation_zip_code_prefix VARCHAR,
  geolocation_lat DOUBLE PRECISION,
  geolocation_lng DOUBLE PRECISION,
  geolocation_city VARCHAR,
  geolocation_state VARCHAR
);

-- Table Order Items
CREATE TABLE order_items(
  order_id VARCHAR,
  order_item_id INT,
  product_id VARCHAR,
  seller_id VARCHAR ,
  shipping_limit_date DATE,
  price DOUBLE PRECISION,
  freight_value DOUBLE PRECISION
);

-- Table Order Payments
CREATE TABLE order_payments(
  order_id VARCHAR,
  payment_sequential INT,
  payment_type VARCHAR,
  payment_installments INT,
  payment_value DOUBLE PRECISION
);

-- Table Order Reviews
CREATE TABLE order_reviews(
  review_id VARCHAR,
  order_id VARCHAR,
  review_score INT,
  review_comment_title VARCHAR,
  review_comment_message VARCHAR,
  review_creation_date DATE,
  review_answer_timestamp DATE
);

-- Create Table Orders
CREATE TABLE orders(
  order_id VARCHAR,
  customer_id VARCHAR,
  order_status VARCHAR,
  order_purchase_timestamp DATE,
  order_approved_at DATE,
  order_deivered_carrier_date DATE,
  order_delivered_customer_date DATE,
  order_estimated_delivery_date DATE
);

-- Table Products
CREATE TABLE product(
  product_id VARCHAR,
  product_category_name VARCHAR,
  product_name_length INT,
  product_description_length INT,
  product_photos_qty INT,
  product_weight_g INT,
  product_length_cm INT,
  product_height_cm INT,
  product_width_cm INT
);

-- Table Sellers
CREATE TABLE sellers(
  seller_id VARCHAR,
  seller_zip_code_prefix VARCHAR,
  seller_city VARCHAR,
  seller_state VARCHAR
);

--- Import Dataset

\ copy customers FROM 'C:\Users\RIKA\Downloads\RAKAMIN\MINI PROJECT 1\Dataset\customers_dataset.csv' DELIMITER ',' CSV HEADER;
\ copy geolocation FROM 'C:\Users\RIKA\Downloads\RAKAMIN\MINI PROJECT 1\Dataset\geolocation_dataset.csv' DELIMITER ',' CSV HEADER;
\ copy order_items FROM 'C:\Users\RIKA\Downloads\RAKAMIN\MINI PROJECT 1\Dataset\order_items_dataset.csv' DELIMITER ',' CSV HEADER;
\ copy order_payments FROM 'C:\Users\RIKA\Downloads\RAKAMIN\MINI PROJECT 1\Dataset\order_payments_dataset.csv' DELIMITER ',' CSV HEADER;
\ copy order_reviews FROM 'C:\Users\RIKA\Downloads\RAKAMIN\MINI PROJECT 1\Dataset\order_reviews_dataset.csv' DELIMITER ',' CSV HEADER;
\ copy orders FROM 'C:\Users\RIKA\Downloads\RAKAMIN\MINI PROJECT 1\Dataset\orders_dataset.csv' DELIMITER ',' CSV HEADER;
\ copy product FROM 'C:\Users\RIKA\Downloads\RAKAMIN\MINI PROJECT 1\Dataset\products_dataset.csv' DELIMITER ',' CSV HEADER;
\ copy sellers FROM 'C:\Users\RIKA\Downloads\RAKAMIN\MINI PROJECT 1\Dataset\sellers_dataset.csv' DELIMITER ',' CSV HEADER;

select * 
from sellers

--- Set Primary Key & Foreign Key

--  Customer’s table Primary Key
ALTER TABLE customers
ADD PRIMARY KEY(customer_id);

-- Set Primary key for product_id
ALTER TABLE product
ADD PRIMARY KEY (product_id);

-- Set Primary key for order_id
ALTER TABLE orders
ADD PRIMARY KEY (order_id);

-- Set Primary key for seller_id
ALTER TABLE sellers
ADD PRIMARY KEY (seller_id);

-- Set Foreign Key order_reviews
ALTER TABLE order_reviews
ADD CONSTRAINT fk_order_reviews
FOREIGN KEY(order_id)
REFERENCES orders;

-- Set Foreign Key order_payments
ALTER TABLE order_payments
ADD CONSTRAINT fk_order_payments
FOREIGN KEY(order_id)
REFERENCES orders;

-- Set Foreign Key orders(customer_id)
ALTER TABLE orders
ADD CONSTRAINT fk_orders
FOREIGN KEY(customer_id)
REFERENCES customers;

-- Set Foreign Key order_items(order_id)
ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_order
FOREIGN KEY (order_id)
REFERENCES orders (order_id);

-- Set Foreign Key order_items(product_id)
ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_product
FOREIGN KEY (product_id)
REFERENCES product (product_id);

-- Set Foreign Key order_items(seller_id)
ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_seller
FOREIGN KEY (seller_id)
REFERENCES sellers (seller_id);

-- Remove duplicate on geolocation_zip_code_prefix 
DELETE FROM geolocation
WHERE ctid NOT IN (
    SELECT min(ctid)
    FROM geolocation
    GROUP BY geolocation_zip_code_prefix
);

-- Set Primary key for geolocation_zip_code_Prefix
ALTER TABLE geolocation
ADD PRIMARY KEY (geolocation_zip_code_prefix);

-- Insert values on Primary key in order to set seller_zip_code_prefix as foreign key
INSERT INTO geolocation (geolocation_zip_code_prefix)
SELECT DISTINCT seller_zip_code_prefix
FROM sellers
WHERE seller_zip_code_prefix NOT IN (
    SELECT geolocation_zip_code_prefix
    FROM geolocation
);


-- Set seller_zip_code_prefix as foreign key 
ALTER TABLE sellers
ADD CONSTRAINT fk_sellers
FOREIGN KEY(seller_zip_code_prefix)
REFERENCES geolocation;


-- Set customer_zip_code_prefix as foreign key
INSERT INTO geolocation (geolocation_zip_code_prefix)
SELECT DISTINCT customer_zip_code_prefix
FROM customers
WHERE customer_zip_code_prefix NOT IN(
	SELECT geolocation_zip_code_prefix
	FROM geolocation
);

-- Set customer_zip_code_prefix as Foreign Key
ALTER TABLE customers
ADD CONSTRAINT fk_customers_geo
FOREIGN KEY(customer_zip_code_prefix)
REFERENCES geolocation;



---  Annual Customer Activity Growth Analysis


-- 1. Average annual monthly active customer

SELECT 
	years,
	ROUND(AVG(monthly_customer_active))avg_monthly_cust_active
FROM(
	SELECT 
		EXTRACT(YEAR FROM order_purchase_timestamp) AS years,
		EXTRACT(MONTH FROM order_purchase_timestamp) AS months,
		COUNT(DISTINCT customer_id) AS monthly_customer_active
	FROM orders
	GROUP BY 1, 2
	ORDER BY 1, 2
)subq
GROUP BY 1
ORDER BY 1;


-- 2. Displaying the number of new customers each year

SELECT
	years,
	COUNT(count_new_customer) new_customer_peryear
FROM(
	SELECT 
		COALESCE(od.order_id, oi.order_id) order_id,
		EXTRACT(YEAR FROM order_purchase_timestamp) years,
		COUNT(order_purchase_timestamp) count_new_customer
	FROM orders od
	LEFT JOIN order_items oi
		ON od.order_id = oi.order_id
	GROUP BY 1,2
	HAVING COUNT(order_purchase_timestamp) < 2
)subq
GROUP BY 1
ORDER BY 1

-- 3. Displaying the number of customers repeat order

SELECT 
	years,
	COUNT(order_id) repeat_order_customer
FROM(
	SELECT
		years,
		order_id,
		COUNT(order_purchase_timestamp) freq_order
	FROM(
		SELECT 
			COALESCE(od.order_id, oi.order_id) order_id,
			EXTRACT(YEAR FROM od.order_purchase_timestamp) years,
			od.order_purchase_timestamp
		FROM orders od
		LEFT JOIN order_items oi
		ON oi.order_id = od.order_id
	)subq1
	GROUP BY 1,2
	HAVING COUNT(order_purchase_timestamp) > 1
)subq2
GROUP BY 1;

-- 4. Average number of orders 

SELECT 
	years,
	ROUND(AVG(cust_order_freq),2) avg_order_frequency_peryear
FROM(
	SELECT
		COALESCE(od.order_id, oi.order_id) order_id,
		EXTRACT(YEAR FROM order_purchase_timestamp) years,
		COUNT(customer_id) cust_order_freq
	FROM orders od
	LEFT JOIN order_items oi
		ON od.order_id = oi.order_id
	GROUP BY 1, 2
)subq
GROUP BY 1
ORDER BY 1;

-- 5. Aggregate the metrics 

SELECT 
	COALESCE(roc.years, aop.years) years,
	avg_monthly_customer_active,
	new_customer_peryear,
	repeat_order_customer,
	avg_order_frequency_peryear
FROM(
	SELECT 
		COALESCE(avn.years, ro.years) years,
		avg_monthly_customer_active,
		new_customer_peryear,
		repeat_order_customer
	FROM(
			SELECT 
				COALESCE(mca.years, ncp.years) years,
				avg_monthly_customer_active,
				new_customer_peryear
			FROM( 
				SELECT 
					years,
					ROUND(AVG(monthly_customer_active)) avg_monthly_customer_active
				FROM(
					SELECT 
						EXTRACT(YEAR FROM order_purchase_timestamp) AS years,
						EXTRACT(MONTH FROM order_purchase_timestamp) AS months,
						COUNT(DISTINCT customer_id) AS monthly_customer_active
					FROM orders
					GROUP BY 1, 2
					ORDER BY 1, 2
				)subq
					GROUP BY 1
					ORDER BY 1
			) mca
			JOIN (
				SELECT
					years,
					COUNT(count_new_customer) new_customer_peryear
				FROM(
					SELECT 
						COALESCE(od.order_id, oi.order_id) order_id,
						EXTRACT(YEAR FROM order_purchase_timestamp) years,
						COUNT(order_purchase_timestamp) count_new_customer
					FROM orders od
					LEFT JOIN order_items oi
						ON od.order_id = oi.order_id
					GROUP BY 1,2
					HAVING COUNT(order_purchase_timestamp) < 2
				)subq
				GROUP BY 1
				ORDER BY 1
			) ncp
			ON mca.years = ncp.years
		) avn
		JOIN (
			SELECT 
				years,
				COUNT(order_id) repeat_order_customer
			FROM(
				SELECT
					years,
					order_id,
					COUNT(order_purchase_timestamp) freq_order
				FROM(
					SELECT 
						COALESCE(od.order_id, oi.order_id) order_id,
						EXTRACT(YEAR FROM od.order_purchase_timestamp) years,
						od.order_purchase_timestamp
					FROM orders od
					LEFT JOIN order_items oi
					ON oi.order_id = od.order_id
				)subq1
				GROUP BY 1,2
				HAVING COUNT(order_purchase_timestamp) > 1
			)subq2
			GROUP BY 1
		) ro
		ON avn.years = ro.years
	) roc
	JOIN (
		SELECT 
			years,
			ROUND(AVG(cust_order_freq),2) avg_order_frequency_peryear
		FROM(
			SELECT
				COALESCE(od.order_id, oi.order_id) order_id,
				EXTRACT(YEAR FROM order_purchase_timestamp) years,
				COUNT(customer_id) cust_order_freq
			FROM orders od
			LEFT JOIN order_items oi
				ON od.order_id = oi.order_id
			GROUP BY 1, 2
		)subq
		GROUP BY 1
		ORDER BY 1
) aop
ON roc.years = aop.years;


---   Annual Product Category Quality Analysis


-- 1. Create a table of total revenue for each year.

CREATE TABLE revenues AS
	SELECT 
		EXTRACT(YEAR FROM od.order_purchase_timestamp) years,
		SUM(oi.price + oi.freight_value) revenue
	FROM order_items oi
	LEFT JOIN orders od
		ON oi.order_id = od.order_id
	WHERE od.order_status IN ('delivered', 'shipped')
	GROUP BY 1;

-- 2. Create a table of total number of cancelled orders for each year. 

CREATE TABLE canceled_orders AS
	SELECT 
		EXTRACT(YEAR FROM od.order_purchase_timestamp) years,
		COUNT(od.order_status) total_canceled_order
	FROM orders od
	LEFT JOIN order_items oi 
		ON oi.order_id = od.order_id
	WHERE order_status = 'canceled'
	GROUP BY 1;

-- 3. Create a table the the highest total revenue of product categories for each year.

CREATE TABLE highest_product_revenues AS
	SELECT
		years,
		product_category_name,
		highest_revenue
	FROM(
		SELECT
			EXTRACT(YEAR FROM od.order_purchase_timestamp) years,
			pr.product_category_name,
			SUM(oi.price + oi.freight_value) highest_revenue,
			ROW_NUMBER() OVER (PARTITION BY EXTRACT(YEAR FROM od.order_purchase_timestamp) 
								   ORDER BY SUM(oi.price + oi.freight_value) DESC) ranking_revenue
		FROM orders od
		JOIN order_items oi 
			ON od.order_id = oi.order_id
		JOIN product pr
			ON oi.product_id = pr.product_id
		WHERE od.order_status 
			IN ('delivered', 'shipped')
		GROUP BY 1, 2
		ORDER BY 1, 4
	) subq
	WHERE ranking_revenue = 1;

-- 4. Create a table the highest number of cancelled orders for each year.

CREATE TABLE highest_canceled_product AS 
	SELECT 
		years,
		product_category_name,
		highest_canceled
	FROM (
		SELECT 
			EXTRACT(YEAR FROM od.order_purchase_timestamp) years,
			pr.product_category_name,
			COUNT(order_status) highest_canceled,
			ROW_NUMBER() OVER(PARTITION BY EXTRACT(YEAR FROM od.order_purchase_timestamp)
							 ORDER BY COUNT(od.order_id) DESC) ranking_canceled
		FROM orders od
		LEFT JOIN order_items oi
			ON od.order_id = oi.order_id
		JOIN product pr
			ON pr.product_id = oi.product_id
		WHERE order_status = 'canceled'
		GROUP BY 1, 2
	) subq
	WHERE ranking_canceled = 1;

-- 5 Aggregate the table.

SELECT 
	rv.years,
	rv.revenue,
	co.total_canceled_order,
	hpr.product_category_name highest_product_revenue,
	hpr.highest_revenue,
	hc.product_category_name highest_canceled_product,
	hc.highest_canceled
FROM revenues rv
LEFT JOIN canceled_orders co
	ON rv.years = co.years 
LEFT JOIN highest_product_revenues hpr
	ON rv.years = hpr.years
LEFT JOIN highest_canceled_product hc
	ON rv.years = hc.years;



---   Annual Payment Type Usage Analysis


-- 1. Total usage of each payment type of all time, sorted from the most popular. 

SELECT 
    payment_type,
    payment_usage_count,
    RANK() OVER (ORDER BY payment_usage_count DESC) as ranking_payment_favorite
FROM
(
    SELECT 
        payment_type,
        SUM(payment_sequential) as payment_usage_count
    FROM order_payments
    GROUP BY payment_type
) subq1
ORDER BY payment_usage_count DESC;

-- 2. The usage of each payment type for each year. 

SELECT 
	EXTRACT(YEAR FROM od.order_purchase_timestamp) years,
	op.payment_type,
	SUM(op.payment_sequential) payment_type_usage_count,
	RANK() OVER (PARTITION BY EXTRACT(YEAR FROM od.order_purchase_timestamp) ORDER BY COUNT(op.payment_type)DESC) rank_payment_type_favorite
FROM order_payments op
JOIN orders od
	ON op.order_id = od.order_id
GROUP BY 1, 2
ORDER BY 1, 4;