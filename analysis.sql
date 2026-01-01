-- Customer Purchase Behavior & Revenue Analysis
-- This project analyzes retail transaction data to understand how customers drive revenue and profit. I combined SQL and Python to clean data, engineer features like revenue and profit, and study sales trends over time. I performed RFM segmentation to classify customers into champions, loyal, at-risk, and lost groups, enabling targeted retention strategies. The analysis shows that a small portion of customers contributes most of the revenue, while some product categories generate higher profit despite lower sales volume. The project demonstrates end-to-end data analysis—from raw data to business recommendations—using realistic, production-style workflows.

-- Total Revenue and Profit
SELECT
    SUM(oi.quantity * oi.price) AS total_revenue,
    SUM((oi.quantity * oi.price) - (oi.quantity * p.cost)) AS total_profit
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id;

-- Monthly Sales Trend
SELECT
    DATE_TRUNC('month', o.order_date) AS month,
    SUM(oi.quantity * oi.price) AS monthly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- Top 10 Customers by Revenue
SELECT
    o.customer_id,
    SUM(oi.quantity * oi.price) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Revenue and Profit by Product Category
SELECT
    p.category,
    SUM(oi.quantity * oi.price) AS revenue,
    SUM((oi.quantity * oi.price) - (oi.quantity * p.cost)) AS profit
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.category;

-- RFM Metrics per Customer
SELECT
    o.customer_id,
    DATE_PART('day', CURRENT_DATE - MAX(o.order_date)) AS recency,
    COUNT(DISTINCT o.order_id) AS frequency,
    SUM(oi.quantity * oi.price) AS monetary
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.customer_id;
