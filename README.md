# Food-Ordering-App-Analysis-using-SQL
## Table of Contents
- [Project Overview](#project-overview)
- [Objectives](#objectives)
- [Process](#process)
- [Tools](#tools)
- [Key Insights](#key-insights)
### Project Overview
This project involved analyzing the data of a food ordering application to gain insights into customer behavior, order patterns, and sales trends. The goal was to understand how customers interact with the app, which outlets are performing best, and how orders and sales accumulate over time. The analysis helps in identifying trends, monitoring performance, and making data-driven business decisions.
### Objective
The objective was to study and analyze the app’s order data to uncover key patterns such as customer order frequency, outlet performance, and sales distribution.
### Process
1. Explored the Dataset:
   - Viewed all records by using dspro.swiggy; table to understand its structure and contents.
      ```sql
      SELECT * FROM dspro.swiggy;
2. Handled Duplicate Records:
   - Identified duplicate rows by counting repeated ids.
     ```sql
     SELECT id, count(id) as duplicate_count
     FROM dspro.swiggy
     GROUP by id
     HAVING count(id) > 1
     ORDER by count(id) desc;
   - Removed duplicates by creating a new table swiggy_copy with only distinct records.
     ```sql
     USE dspro;
     CREATE table dspro.swiggy_copy AS
     SELECT distinct * FROM dspro.swiggy;
   - Replaced the original table with the cleaned table.
      ```sql
      DROP table dspro.swiggy;
      ALTER table dspro.swiggy_copy RENAME to Swiggy;
      SELECT * FROM dspro.swiggy;
3. Limited Record Viewing:
   - Extracted a subset of rows (from row 4 to 9) to inspect sample data for verification.
      ```sql
     SELECT * FROM dspro.swiggy
     LIMIT 3, 7;
4. Found Latest Orders:
   - Used a Common Table Expression (CTE) with ROW_NUMBER() partitioned by customer (cust_id) and ordered by order_date descending.
   - Filtered to get the most recent order for each customer.
      ```sql
      With latest_orders AS
      (Select cust_id, outlet, order_date,
      row_number() over(partition by cust_id order by order_date desc) as latest_order_dt
      from dspro.swiggy)
      Select cust_id, outlet, order_date from latest_orders where latest_order_dt = 1;
5. Handled Null Values in Comments:
   - Replaced null values in the comments column with “No Issues” using the COALESCE function for better readability.
      ```sql
      SELECT order_id, partner_code, order_date, coalesce(comments, 'No Issues')
      AS comments
      FROM dspro.swiggy;
6. Outlet-wise Analysis:
   - Calculated order count and total bill amount for each outlet.
   - Computed cumulative order counts and cumulative bill amounts using variables for running totals.
      ```sql
      SELECT a.outlet, a.order_count,
      @runnig_ord_cnt := @runnig_ord_cnt + a.order_count AS Cummulative_count,
      a.total_sale, @running_bill_amt := @running_bill_amt + a.total_sale
      FROM
      (SELECT outlet, count(order_id) as order_count, sum(bill_amount) as total_sale 
      FROM dspro.swiggy
      GROUP by outlet) as a
      JOIN
      (SELECT @runnig_ord_cnt := 0, @running_bill_amt := 0) as b
      ORDER by 1;
7. Customer-wise and Outlet-wise Summary:
   - Created a cross-tab summary showing, for each customer, the total number of orders from each outlet (KFC, Dominos, Pizza Hut).
   - Used conditional aggregation to compute outlet-specific counts.
      ```sql
      SELECT cust_id,
      sum(if(outlet = 'KFC', 1,0)) KFC,
      sum(if(outlet = 'Dominos', 1,0)) Dominos,
      sum(if(outlet = 'Pizza hut', 1,0)) Pizza_hut
      FROM dspro.swiggy
      GROUP by 1;
### Key Insights
- Pizza Hut and KFC had the highest number of orders and sales; cumulative totals highlight top contributors.
- Most orders were delivered on time, with only a few delivery issues reported.

   
   
   




   
