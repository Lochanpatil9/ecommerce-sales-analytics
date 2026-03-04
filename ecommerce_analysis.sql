/* ======================================================
   E-COMMERCE SALES ANALYTICS PROJECT
   Author: Lochan Patil
   Description:
   SQL analysis of e-commerce sales data to understand
   revenue trends, product performance, and customer behavior.
   ====================================================== */


/* ======================================================
   1. DATA EXPLORATION
   ====================================================== */

-- Total number of orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- Total number of customers
SELECT COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers;

-- Total number of products
SELECT COUNT(DISTINCT product_id) AS total_products
FROM products;



/* ======================================================
   2. REVENUE ANALYSIS
   ====================================================== */

-- Total revenue
SELECT 
SUM(price + freight_value) AS total_revenue
FROM order_items;

-- Average order value
SELECT 
SUM(price + freight_value) / COUNT(DISTINCT order_id) AS avg_order_value
FROM order_items;



/* ======================================================
   3. MONTHLY REVENUE TREND
   ====================================================== */

SELECT 
FORMAT(o.order_purchase_timestamp,'yyyy-MM') AS order_month,
SUM(oi.price + oi.freight_value) AS monthly_revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY FORMAT(o.order_purchase_timestamp,'yyyy-MM')
ORDER BY order_month;



/* ======================================================
   4. PRODUCT CATEGORY PERFORMANCE
   ====================================================== */

-- Revenue by product category
SELECT 
p.product_category_name,
SUM(oi.price + oi.freight_value) AS category_revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY category_revenue DESC;



/* ======================================================
   5. REGIONAL SALES ANALYSIS
   ====================================================== */

-- Revenue by customer state
SELECT 
c.customer_state,
SUM(oi.price + oi.freight_value) AS state_revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY state_revenue DESC;



/* ======================================================
   6. CUSTOMER BEHAVIOR ANALYSIS
   ====================================================== */

-- Repeat customer rate
WITH customer_orders AS (
SELECT 
c.customer_unique_id,
COUNT(o.order_id) AS order_count
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
)

SELECT 
COUNT(CASE WHEN order_count > 1 THEN 1 END) * 100.0 / COUNT(*) 
AS repeat_customer_percentage
FROM customer_orders;



/* ======================================================
   7. CATEGORY DEMAND ANALYSIS
   ====================================================== */

-- Units sold per category
SELECT 
p.product_category_name,
COUNT(*) AS units_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY units_sold DESC;



/* ======================================================
   8. TOP CUSTOMERS
   ====================================================== */

-- Customers generating highest revenue
SELECT 
c.customer_unique_id,
SUM(oi.price + oi.freight_value) AS customer_revenue
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY customer_revenue DESC;
