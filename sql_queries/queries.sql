CREATE DATABASE ecommerce;
USE ecommerce;

SET GLOBAL local_infile = 1;

USE ecommerce;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv'
INTO TABLE olist_orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT * FROM olist_orders LIMIT 10;
SELECT COUNT(*) FROM olist_orders;
SELECT order_status, COUNT(*) AS total_orders
FROM olist_orders
GROUP BY order_status;

-- Creating table 
CREATE TABLE olist_order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);
-- Import data

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_items_dataset.csv'
INTO TABLE olist_order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM olist_order_items;

SELECT 
    o.order_id,
    o.order_status,
    oi.price
FROM olist_orders o
JOIN olist_order_items oi
ON o.order_id = oi.order_id
LIMIT 10;

SELECT 
    SUM(price) AS total_revenue
FROM olist_order_items;

SELECT 
    o.order_id,
    SUM(oi.price) AS order_revenue
FROM olist_orders o
JOIN olist_order_items oi
ON o.order_id = oi.order_id
GROUP BY o.order_id
LIMIT 10;

SELECT 
    o.order_id,
    SUM(oi.price) AS revenue
FROM olist_orders o
JOIN olist_order_items oi
ON o.order_id = oi.order_id
GROUP BY o.order_id
ORDER BY revenue DESC
LIMIT 10;

CREATE TABLE olist_products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv'
INTO TABLE olist_products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DROP TABLE olist_products;
CREATE TABLE olist_products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_lenght INT NULL,
    product_description_lenght INT NULL,
    product_photos_qty INT NULL,
    product_weight_g INT NULL,
    product_length_cm INT NULL,
    product_height_cm INT NULL,
    product_width_cm INT NULL
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv'
INTO TABLE olist_products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
product_id,
product_category_name,
@product_name_lenght,
@product_description_lenght,
@product_photos_qty,
@product_weight_g,
@product_length_cm,
@product_height_cm,
@product_width_cm
)
SET
product_name_lenght = NULLIF(@product_name_lenght,''),
product_description_lenght = NULLIF(@product_description_lenght,''),
product_photos_qty = NULLIF(@product_photos_qty,''),
product_weight_g = NULLIF(@product_weight_g,''),
product_length_cm = NULLIF(@product_length_cm,''),
product_height_cm = NULLIF(@product_height_cm,''),
product_width_cm = NULLIF(@product_width_cm,'');
SELECT COUNT(*) FROM olist_products;
SELECT 
    p.product_category_name,
    SUM(oi.price) AS revenue
FROM olist_order_items oi
JOIN olist_products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;
SELECT 
    p.product_category_name,
    SUM(oi.price) AS revenue
FROM olist_order_items oi
JOIN olist_products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;
SELECT 
    YEAR(o.order_purchase_timestamp) AS year,
    MONTH(o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS revenue
FROM olist_orders o
JOIN olist_order_items oi
ON o.order_id = oi.order_id
GROUP BY year, month
ORDER BY year, month;
SELECT 
    o.order_id,
    SUM(oi.price) AS revenue
FROM olist_orders o
JOIN olist_order_items oi
ON o.order_id = oi.order_id
GROUP BY o.order_id
ORDER BY revenue DESC
LIMIT 10;

CREATE TABLE olist_customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv'
INTO TABLE olist_customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) FROM olist_customers;
SELECT 
    c.customer_state,
    SUM(oi.price) AS revenue
FROM olist_orders o
JOIN olist_order_items oi
    ON o.order_id = oi.order_id
JOIN olist_customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY revenue DESC;
SELECT 
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM olist_orders o
JOIN olist_customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC
LIMIT 5;
SELECT 
    p.product_category_name,
    SUM(oi.price) AS revenue
FROM olist_order_items oi
JOIN olist_products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;
SELECT 
    c.customer_state,
    SUM(oi.price) AS revenue
FROM olist_orders o
JOIN olist_order_items oi
    ON o.order_id = oi.order_id
JOIN olist_customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY revenue DESC;
SELECT 
    YEAR(o.order_purchase_timestamp) AS year,
    MONTH(o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS revenue
FROM olist_orders o
JOIN olist_order_items oi
ON o.order_id = oi.order_id
GROUP BY year, month
ORDER BY year, month;
SELECT 
    order_status,
    COUNT(*) AS total_orders
FROM olist_orders
GROUP BY order_status;
SELECT 
    o.order_id,
    SUM(oi.price) AS revenue
FROM olist_orders o
JOIN olist_order_items oi
ON o.order_id = oi.order_id
GROUP BY o.order_id
ORDER BY revenue DESC
LIMIT 10;

SELECT 
    order_status,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM olist_orders), 2) AS percentage
FROM olist_orders
GROUP BY order_status
ORDER BY total_orders DESC;

SELECT 
    ROUND(SUM(price), 2) AS product_revenue,
    ROUND(SUM(freight_value), 2) AS freight_revenue,
    ROUND(SUM(price) + SUM(freight_value), 2) AS total_transaction_value,
    ROUND(SUM(freight_value) / SUM(price) * 100, 2) AS freight_percentage
FROM olist_order_items;

SELECT 
    p.product_category_name,
    COUNT(oi.order_item_id) AS total_items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS avg_item_price,
    ROUND(SUM(oi.price) * 100.0 / 
        (SELECT SUM(price) FROM olist_order_items), 2) AS revenue_share_pct
FROM olist_order_items oi
JOIN olist_products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;
SELECT 
    p.product_category_name,
    COUNT(oi.order_item_id) AS total_items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM olist_order_items oi
JOIN olist_products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue ASC
LIMIT 10;
SELECT 
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp),
    SUM(oi.price)
FROM olist_orders o
JOIN olist_order_items oi
ON o.order_id = oi.order_id
GROUP BY 
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY 
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp);
    SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    SUM(oi.price) AS total_revenue
FROM olist_orders o
JOIN olist_order_items oi
ON o.order_id = oi.order_id
GROUP BY 
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY 
    order_year,
    order_month;
    SELECT 
    YEAR(o.order_purchase_timestamp) AS y,
    MONTH(o.order_purchase_timestamp) AS m,
    SUM(oi.price) AS revenue
FROM olist_orders o
JOIN olist_order_items oi
ON o.order_id = oi.order_id
GROUP BY 
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY 
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp);
    SELECT 
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM olist_orders o
JOIN olist_order_items oi
ON o.order_id = oi.order_id
JOIN olist_customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;
SELECT 
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp,
    COUNT(oi.order_item_id) AS items_count,
    ROUND(SUM(oi.price), 2) AS order_revenue,
    ROUND(AVG(oi.price), 2) AS avg_item_price
FROM olist_orders o
JOIN olist_order_items oi
ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_status, o.order_purchase_timestamp
ORDER BY order_revenue DESC
LIMIT 10;
SELECT 
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM olist_orders o
JOIN olist_order_items oi
ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';
SELECT 
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 1) AS avg_delivery_days,
    ROUND(AVG(DATEDIFF(o.order_estimated_delivery_date, o.order_purchase_timestamp)), 1) AS avg_estimated_days,
    ROUND(AVG(DATEDIFF(o.order_estimated_delivery_date, o.order_delivered_customer_date)), 1) AS delivery_gap
FROM olist_orders o
WHERE o.order_status = 'delivered'
AND o.order_delivered_customer_date IS NOT NULL;
SELECT 
    customer_order_count,
    COUNT(*) AS number_of_customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS customer_order_count
    FROM olist_orders o
    JOIN olist_customers c
    ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
) t
GROUP BY customer_order_count
ORDER BY customer_order_count;
