# Retail Category Analytics — SQL + Power BI

## Business Question
Among all product categories, which combine strong revenue growth momentum with 
low delivery-related customer dissatisfaction risk — making them safe bets for 
expanded seller partnerships and inventory investment next quarter? And which 
categories are growing but held back by delivery reliability problems that need 
fixing before further investment?

This mirrors a real decision a retail category/inventory manager has to make with 
a limited budget: where to put money next quarter, and where to fix operations first.

## Why this dataset
Using the Brazilian E-Commerce Public Dataset by Olist (Kaggle) — a multi-table 
marketplace dataset (orders, order items, products, customers, sellers, payments, 
reviews) with real delivery timing and customer review data. Chosen over a single 
flat-file dataset (e.g. Superstore) specifically because answering the business 
question above requires joining across order, delivery, and review data — not just 
aggregating one table.

## Approach
1. SQL (PostgreSQL): multi-table joins, staged CTEs for category-level revenue 
   trend and delivery-risk metrics, window functions for month-over-month growth 
   and quadrant ranking
2. Power BI: dashboard built on top of the SQL output, centered on a growth-vs-risk 
   quadrant view
3. Written narrative: the business question, method, finding, and recommendation

## Status
Work in progress. Currently in setup — schema loaded, relationships mapped. 
SQL analysis and dashboard to follow.

## Stack
PostgreSQL, Power BI, [DBeaver/pgAdmin — whichever you land on]
