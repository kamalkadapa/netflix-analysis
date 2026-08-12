-- Total customers
select count(distinct customer_id) from retail_data;

-- average purchase
select avg(`Purchase Amount (USD)`) from retail_data;

-- maximum purchase
select max(purchase_amount) from retail_data;

-- minimum purchase
select min(purchase_amount) from retail_data;

-- Distinct locations
select distinct location from retail_data;

-- Distinct colors
select distinct color from retail_data;

-- Average purchase by gender
select gender,avg(purchase_amount) from retail_data group by gender;

-- Top 10 spending customers
select customer_id,sum(purchase_amount) as top_spending
from retail_data group by customer_id order by top_spending desc limit 10;

-- Highest spending locations
select location,sum(purchase_amount) as high_spending
from retail_data group by location order by high_spending desc;

-- season wise sales
select season,count(purchase_amount) as no_of_sales
from retail_data group by season ;

-- average rating by color
select color,avg(review_rating) from retail_data group by color;

-- Payment method distribution
select payment_method,count(*) as total_transactions from retail_data group by payment_method order by total_transactions desc;

-- Subscription vs Non-subscription sales
select subscription_status,count(*) as total_sales from retail_data
group by subscription_status;

-- Discount analysis
select discount_applied,count(*) as total_sales from retail_data
group by discount_applied;

-- Average purchases by age group
select age_group,avg(previous_purchases) as avg_purchases from retail_data group by age_group;

-- Most popular size
select size,sum(previous_purchases) as popular_size from retail_data group by size order by popular_size desc limit 1;

-- Rank customers
select customer_id,total_purchase,row_number() over(order by total_purchase desc) as cust_rank
from
(select customer_id,sum(purchase_amount) as total_purchase from retail_data group by customer_id) as t  ;

-- Dense rank
select customer_id,total_purchase,dense_rank() over(order by total_purchase desc) as cust_rank
from
(select customer_id,sum(purchase_amount) as total_purchase from retail_data group by customer_id) as t;

-- NTILE
select customer_id,total_purchase,ntile(20) over(order by total_purchase desc) as cust_category
from
(select customer_id,sum(purchase_amount) as total_purchase from retail_data group by customer_id) as t; 

-- Customers who spent more than previous customers(using lag)
SELECT *
FROM 
(SELECT customer_id,purchase_amount,LAG(purchase_amount) OVER (ORDER BY customer_id) AS previous_purchase
FROM retail_data) AS t
WHERE purchase_amount > previous_purchase;

-- Customers who spent more than next customers(using lead)
SELECT *
FROM 
(SELECT customer_id,purchase_amount,LEAD(purchase_amount) OVER (ORDER BY customer_id) AS next_purchase
FROM retail_data) AS t
WHERE purchase_amount > next_purchase;

-- Running Total
select customer_id,purchase_amount,sum(purchase_amount) over(order by customer_id) as running_total
from retail_data;

-- Moving average
select customer_id,purchase_amount,avg(purchase_amount) over(order by customer_id) as moving_average
from retail_data;

-- Find top customers
with cte as(select customer_id,sum(purchase_amount) as total_spent from retail_data
group by customer_id)
select * from cte where total_spent>500;

-- Customers spending above average
with cte as(select customer_id,sum(purchase_amount) as total_spent from retail_data
group by customer_id)
select * from cte where total_spent>(select avg(purchase_amount) from retail_data);

-- sales summary(using views)
create view sales_summary as(
select
count(*) as no_of_customers,
sum(purchase_amount) as tot_sales,
avg(purchase_amount) as avg_sales,
max(purchase_amount) as highest_purchase,
min(purchase_amount) as lowest_purchase
from retail_data);
select * from sales_summary;

-- Customers summary(using views)
create view customer_summary as(
select customer_id, 
count(*) as no_of_customers,
sum(purchase_amount) as tot_sales,
avg(purchase_amount) as avg_sales,
max(purchase_amount) as highest_purchase,
min(purchase_amount) as lowest_purchase
from retail_data group by customer_id);
select * from customer_summary;

-- Subscription summary view
create view subscription_summary as(
select  
count(*) as no_of_customers,
sum(purchase_amount) as tot_sales,
avg(purchase_amount) as avg_sales,
max(purchase_amount) as highest_purchase,
min(purchase_amount) as lowest_purchase
from retail_data group by subscription_status);
select * from subscription_summary;

-- get customer history
call get_customer_history(103);

-- get season sales
call get_season_sales();

-- get top location
call get_top_locations();

