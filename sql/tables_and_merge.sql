CREATE DATABASE ecommerce_db;
USE ecommerce_db;
SELECT DATABASE();

/*
=========================================================
Project: E-commerce Order Fulfillment & Reconciliation Analysis
File: 01_create_tables_and_merge.sql

Purpose:
1. Create clean PostgreSQL tables
2. After CSV import, create one final merged dataset

Important:
Run Section A first.
Then import cleaned CSV files.
Then run Section B to create the merged dataset.
=========================================================
*/

DROP TABLE IF EXISTS ecommerce_orders_merged_final;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id TEXT,
    customer_zip_code_prefix INT,
    customer_city TEXT,
    customer_state TEXT
);

SHOW TABLES;
DESCRIBE customers;

CREATE TABLE order_items (
    order_id TEXT,
    product_id TEXT,
    seller_id TEXT,
    price NUMERIC(12,2),
    shipping_charges NUMERIC(12,2)
);

CREATE TABLE orders (
    order_id TEXT,
    customer_id TEXT,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP
);

CREATE TABLE payments (
    order_id TEXT,
    payment_sequential INT,
    payment_type TEXT,
    payment_installments INT,
    payment_value NUMERIC(12,2)
);

CREATE TABLE products (
    product_id TEXT,
    product_category_name TEXT,
    product_weight_g NUMERIC(12,2),
    product_length_cm NUMERIC(12,2),
    product_height_cm NUMERIC(12,2),
    product_width_cm NUMERIC(12,2),
    product_volume_cm3 NUMERIC(18,2)
);


SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM payments;
SELECT COUNT(*) FROM products;

DROP TABLE IF EXISTS ecommerce_orders_final;

CREATE TABLE ecommerce_orders_final AS
WITH item_summary AS (
    SELECT
        oi.order_id,
        COUNT(*) AS total_items,
        COUNT(DISTINCT oi.product_id) AS unique_products,
        COUNT(DISTINCT oi.seller_id) AS unique_sellers,
        ROUND(SUM(oi.price), 2) AS product_revenue,
        ROUND(SUM(oi.shipping_charges), 2) AS shipping_charges,
        ROUND(SUM(oi.price + oi.shipping_charges), 2) AS total_order_value,
        ROUND(
            SUM(oi.shipping_charges) * 100.0 / NULLIF(SUM(oi.price), 0),
            2
        ) AS shipping_to_price_pct
    FROM order_items oi
    GROUP BY oi.order_id
),

payment_summary AS (
    SELECT
        p.order_id,
        COUNT(*) AS payment_rows,
        ROUND(SUM(p.payment_value), 2) AS payment_value,
        MAX(p.payment_installments) AS max_installments,
        MIN(p.payment_type) AS main_payment_type
    FROM payments p
    GROUP BY p.order_id
),

product_summary AS (
    SELECT
        oi.order_id,
        COUNT(DISTINCT pr.product_category_name) AS unique_categories,
        MIN(pr.product_category_name) AS main_product_category,
        ROUND(AVG(pr.product_weight_g), 2) AS avg_product_weight_g,
        ROUND(AVG(
            pr.product_length_cm * pr.product_height_cm * pr.product_width_cm
        ), 2) AS avg_product_volume_cm3
    FROM order_items oi
    LEFT JOIN products pr
        ON oi.product_id = pr.product_id
    GROUP BY oi.order_id
)

SELECT
    o.order_id,
    o.customer_id,
    c.customer_city,
    c.customer_state,

    o.order_purchase_timestamp,
    o.order_approved_at,
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01') AS order_month,

    i.total_items,
    i.unique_products,
    i.unique_sellers,
    i.product_revenue,
    i.shipping_charges,
    i.total_order_value,
    i.shipping_to_price_pct,

    ps.unique_categories,
    ps.main_product_category,
    ps.avg_product_weight_g,
    ps.avg_product_volume_cm3,

    p.payment_rows,
    p.main_payment_type,
    p.max_installments,
    p.payment_value,

    ROUND(
        COALESCE(p.payment_value, 0) - COALESCE(i.total_order_value, 0),
        2
    ) AS payment_difference,

    CASE
        WHEN p.payment_value IS NULL THEN 'missing_payment'
        WHEN ABS(p.payment_value - i.total_order_value) <= 1 THEN 'matched'
        ELSE 'potential_gap'
    END AS payment_match_status

FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
LEFT JOIN item_summary i
    ON o.order_id = i.order_id
LEFT JOIN payment_summary p
    ON o.order_id = p.order_id
LEFT JOIN product_summary ps
    ON o.order_id = ps.order_id;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS distinct_orders
FROM ecommerce_orders_final;

SELECT *
FROM ecommerce_orders_final
LIMIT 10;

SELECT *
FROM ecommerce_orders_final;
