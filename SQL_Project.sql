Create table dspro.swiggy
(
Id int, 
Cust_id varchar(20), 
Order_id int,
Partner_code int, 
Outlet varchar(50),
Bill_amount int, 
Order_date date, 
Comments Varchar(100)
);
# insert data into the table
INSERT INTO dspro.swiggy
VALUES
(1, 'SW1005', 700, 50, 'KFC', 753, '2021-10-10', 'Door locked'),
(2, 'SW1006', 710, 59, 'Pizza hut', 1496, '2021-09-01', 'In-time delivery'),
(3, 'SW1005', 720, 59, 'Dominos', 990, '2021-12-10', NULL),
(4, 'SW1005', 707, 50, 'Pizza hut', 2475, '2021-12-11', NULL),
(5, 'SW1006', 770, 59, 'KFC', 1250, '2021-11-17', 'No response'),
(6, 'SW1020', 1000, 119, 'Pizza hut', 1400, '2021-11-18', 'In-time-delivery'),
(7, 'SW2035', 1079, 135, 'Dominos', 1750, '2021-11-19', NULL),
(8, 'SW1020', 1083, 59, 'KFC', 1250, '2021-11-20', NULL),
(11, 'SW1020', 1100, 150, 'Pizza hut', 1950, '2021-12-24', 'Late delivery'),
(9, 'SW2035', 1095, 119, 'Pizza hut', 1270, '2021-11-21', 'Late delivery'),
(10, 'SW1005', 729, 135, 'KFC', 1000, '2021-09-10', 'Delivered'),
(1, 'SW1005', 700, 50, 'KFC', 753, '2021-10-10', 'Door locked'),
(2, 'SW1006', 710, 59, 'Pizza hut', 1496, '2021-09-01', 'In-time delivery'),
(3, 'SW1005', 720, 59, 'Dominos', 990, '2021-12-10', NULL),
(4, 'SW1005', 707, 50, 'Pizza hut', 2475, '2021-12-11', NULL );

SELECT * from dspro.swiggy;

# Finding the count of duplicate rows in the swiggy table. 
Select id, count(id) as duplicate_count
FROM dspro.swiggy
Group by id
Having count(id) > 1
Order by count(id) desc;

#  Remove Duplicate records from the table. 
USE dspro;
Create table dspro.swiggy_copy AS
Select distinct * from dspro.swiggy;

DROP table dspro.swiggy;

Alter table dspro.swiggy_copy Rename to Swiggy;

Select * from dspro.swiggy;

#  Print records from row number 4 to 9. 
Select * from dspro.swiggy
Limit 3, 7;

# Find the latest order placed by customers. Refer to the output below  

With latest_orders AS
(Select cust_id, outlet, order_date,
row_number() over(partition by cust_id order by order_date desc) as latest_order_dt
from dspro.swiggy)
Select cust_id, outlet, order_date from latest_orders where latest_order_dt = 1;

#  Print order_id, partner_code, order_date, comment (No issues in place of null else comment).
Select order_id, partner_code, order_date, coalesce(comments, 'No Issues')
AS comments
from dspro.swiggy;

# Print outlet wise order count, cumulative order count, total bill_amount, cumulative bill_amount. 
Select a.outlet, a.order_count, @runnig_ord_cnt := @runnig_ord_cnt + a.order_count as Cummulative_count,
a.total_sale, @running_bill_amt := @running_bill_amt + a.total_sale
from
(Select outlet, count(order_id) as order_count, sum(bill_amount) as total_sale 
From dspro.swiggy
Group by outlet) as a
JOIN
(Select @runnig_ord_cnt := 0, @running_bill_amt := 0) as b
Order by 1;

# Print cust_id wise, Outlet wise 'total number of orders'.

Select cust_id,
sum(if(outlet = 'KFC', 1,0)) KFC,
sum(if(outlet = 'Dominos', 1,0)) Dominos,
sum(if(outlet = 'Pizza hut', 1,0)) Pizza_hut
from dspro.swiggy
group by 1;


