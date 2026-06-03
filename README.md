# E-commerce Customer Segmentation, Shipping & Seller Performance Analysis

## Project Overview

SQL-driven e-commerce analytics project using 5 relational CSV files: customers, orders, order items, payments, and products.

The project analyzes customer purchase segments, order value trends, product categories, shipping cost pressure, seller performance, payment methods, and regional performance.

## Tools Used

**MySQL, Python, Pandas, NumPy, Matplotlib, Seaborn, Power BI**

## Business Questions

* Which customer segments generate the highest order value?
* Which product categories and states contribute most to total order value?
* Which sellers have high shipping-to-price pressure?
* What payment methods are most used?
* How is order value changing over time?

## Workflow

1. Loaded and checked train/test CSV files in Python.
2. Cleaned dates, text fields, missing values, duplicate keys, and invalid numeric values.
3. Exported cleaned CSV files for SQL import.
4. Created MySQL tables and merged all five datasets into one order-level table.
5. Ran SQL validation and business analysis queries.
6. Created customer segmentation and seller shipping analysis.
7. Built a two-page Power BI dashboard.
8. Wrote insights and recommendations from actual SQL/dashboard results.

## Final Dataset

Final merged SQL output:

```text
ecommerce_orders_merged_final.csv
```

This order-level dataset includes customer location, order month, product revenue, shipping charges, total order value, product category, seller-related metrics, payment method, and payment quality checks.

## SQL Analysis

Key SQL analysis areas:

* KPI summary
* Monthly order value trend
* Product category performance
* Customer state performance
* RFM-based customer segmentation
* Revenue by customer segment
* Seller order value analysis
* Seller shipping-to-price ratio ranking
* Payment method summary
* Data validation checks

## Dashboard

### Page 1: Customer & Order Value Overview

* Total Orders
* Total Customers
* Product Revenue
* Total Order Value
* Average Order Value
* Monthly Order Value Trend
* Customer Segment Breakdown
* Revenue by Customer Segment
* Top Categories by Order Value
* Top States by Order Value

### Page 2: Shipping & Seller Performance

* Shipping Charges
* Shipping-to-Price %
* Total Sellers
* Average Seller Order Value
* High Freight Sellers
* Shipping-to-Price by Category
* Top Sellers by Order Value
* High Freight Ratio Sellers
* Payment Type Share

## Key Insights

Final insights are based on actual SQL and dashboard results.

Example insight areas:

* High-value customer segments and their revenue contribution
* Low-frequency customer retention opportunity
* Sellers with high shipping-to-price pressure
* Top-performing categories and states
* Payment method patterns

## Limitations

* Payment differences were treated as a data quality observation, not confirmed revenue leakage.
* Delivery and review score analysis were not included because those fields were not available.
* Seller performance was measured using order value and shipping-to-price ratio, not ratings.
* RFM segmentation is a purchase-behavior analysis, not a prediction model.
* Test files were used only for schema checking.