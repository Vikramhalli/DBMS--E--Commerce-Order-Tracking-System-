📦 E-Commerce Order Tracking System

A complete backend database solution for managing and automating the order lifecycle of an e-commerce platform.
This project includes table creation scripts, triggers, stored procedures, and functions that ensure data accuracy, automation, and analytical insights for online retail operations.

 Overview

The E-Commerce Order Tracking System manages products, customers, orders, order details, shipments, returns, and reviews.
Automation is achieved using SQL triggers (for inventory updates & order totals), stored procedures (for history retrieval, returns processing, and sales reporting), and analytical functions (revenue, ratings, LTV).

This repository is ideal for:

Students learning advanced SQL

Academic DBMS projects

Backend architecture demos

Real-world e-commerce prototypes

 Key Features
->Inventory & Order Management

Auto-update stock when an order is created

Prevent negative stock levels

Auto-calculate total order amount

-> Shipment Tracking

Store tracking numbers, delivery dates, courier details

Link shipments directly with orders

-> Return Processing

Manage return requests

Restore stock for approved returns

Maintain clear return status

->Advanced Reporting & Analytics

Customer order history (via stored procedure)

Date-range sales report

Calculate:

Product revenue

Customer lifetime value (LTV)

Average product rating

-> Well-Structured Database

Normalized relational schema

Clean and modular SQL scripts

Easy to integrate with frontend/backend applications
E-Commerce-Order-Tracking-System
 ┣ 📜 main.py
 ┣ 📜 database.sql
 ┗ 📜 README.md
 Database Components
1. Tables Included

PRODUCTS

CUSTOMERS

ORDERS

ORDER_DETAILS

SHIPMENTS

RETURNS

REVIEWS

2. Triggers

Update product stock after order is placed

Prevent negative inventory

Recalculate total order amount

3. Stored Procedures

get_customer_order_history()

process_product_return()

generate_sales_report()

4. Functions

calculate_product_revenue()

calculate_customer_ltv()

get_average_rating()

🛠 How to Use

Import SQL files into MySQL / MariaDB.

Execute the table creation script.

Execute all triggers, procedures, and functions.

Start inserting sample data and test the automation:

Insert order → stock auto updates

Approve return → stock restored

Generate reports → run stored procedures

📊 Example Use Cases

E-commerce order management systems

Sales reporting dashboards

Inventory automation tools

Customer analytics applications

🤝 Contribution

Feel free to fork this repo, improve it, and submit pull requests.
Suggestions and enhancements are always welcome!

📝 License

This project is for educational and development purposes.
You are free to use and modify it.
