create database walmart;

use walmart;
select * from walmart;
describe walmart;

update walmart
set unit_price = trim(replace(unit_price, '$', ''));

alter table walmart
modify column unit_price DECIMAL(10,2);

select count(distinct Branch) as Total_Branch from walmart;
select sum(unit_price*quantity) as Total_Sales from walmart;

alter table walmart
add column Price decimal(10,2);

UPDATE walmart
SET Price = unit_price * quantity;

# Total number of sales (invoices)
select count(invoice_id) as total_invoices from walmart;	-- 10020

# Total revenue
select sum(Price) as Total_Slaes from walmart;	-- 1214825.38

# Average profit margin
SELECT 
    round(AVG(profit_margin),2) AS Avg_Profit_Margin
FROM
    walmart;	-- 0.3937215568862092

# Top 5 categories by revenue
select 
	category, 
    round(Sum(Price)) as Total_Revenue
from walmart 
group by category
order by Total_Revenue asc limit 5;

# Most profitable category:
select 
	category, 
    round(avg(profit_margin),3) as Avg_Profit 
from walmart
group by category
order by Avg_Profit desc limit 5;

# Branch / City Performance (Revenue by city)
select 
	City,
    round(Sum(Price),2) as Total_Revenue
from walmart
group by City
order by Total_Revenue desc limit 5;
    
# Branch / City Performance (Best performing branch)
select 
	Branch,
    round(Sum(Price),2) as Total_Revenue
from walmart
group by Branch
order by Total_Revenue desc limit 5;


# Branch performing
with branch_sales as (
select
	Branch,
    Sum(Price) as Total_Sales,
    rank() over(order by Sum(Price) desc) as rank_position
from walmart
group by Branch
)
select
*
from branch_sales 
where rank_position = 1;


# Customer Behavior (Most used payment method)
select 
	distinct payment_method,
    count(*) As Count
from walmart
group by payment_method
order by Count desc;


# Average rating per category
select 
	category, 
    round(avg(rating),2) as AVG_Rating
from walmart
group by category
order by 2 desc;


# Sales by day of week
select
	dayname(date),
	round(sum(Price),2) as total_sales
from walmart
group by 1
order by 2 desc;

select max(date) from walmart;
select min(date) from walmart;

# date format
update walmart
set date = str_to_date(date, '%d/%m/%Y');
describe walmart;

# Peak sales hours
SELECT HOUR(time) AS sales_hour, Sum(Price) AS total_sales
FROM walmart
GROUP BY HOUR(time)
ORDER BY total_sales DESC;

# Monthly Sales Trend
select 
	date_format(date, '%Y-%m') as Sales_Month,
    sum(Price) as Total_Sales
from walmart
group by Sales_Month
order by Sales_Month asc;


SELECT DISTINCT MONTH(date) AS month_count, sum(Price) as Total_Sales
FROM walmart
WHERE YEAR(date) = 2019
group by month_count
ORDER BY month_count;


# City wise which category give highest revenue
with revenue_per_category AS(
	select
		City,
        category,
        sum(Price) as Total_Revenue
	from walmart
    group by City, category
),
ranked_category AS(
	select
    City,
    category,
    Total_Revenue,
    Rank() over (partition by City order by Total_Revenue desc) as rnk
    from revenue_per_category
)
select 
	City,
    category,
    Total_Revenue
from ranked_category
where rnk = 1;

select * from walmart;
select distinct category from walmart;
select distinct City from walmart;


# Top 3 Categories by City (Profit Margin)
with ranked_position as (
SELECT 
    City,
    category,
    AVG(profit_margin) AS avg_profit,
    RANK() OVER (PARTITION BY City ORDER BY AVG(profit_margin) DESC) AS rank_position
FROM walmart
GROUP BY City, category
)
select 
*
from ranked_position
where rank_position <=3;


# Monthly Sales Growth Trend (last 6 months)
select
date_format(date, '%d-%m-%Y') as month_num,
sum(Price) as Total_Revenue
from walmart
where date>= date_sub('2023-12-31', interval 6 month)
group by month_num
order by month_num;

# Peak Hours of the Day
select 
	hour(time) as Sales_Hour,
	sum(Price) as Total_Sales
from walmart
group by Sales_Hour
order by Total_Sales desc;


# Avg Payment Rating vs Profit Margin
select
	Branch,
	round(avg(rating),2) as Avg_Rating,
    round(avg(profit_margin),2) as Avg_Profit
from walmart
group by Branch
order by Avg_Rating desc;


# Top 5 Invoices by Sales Value
select 
invoice_id,
round(sum(Price),2) as Total_Sales
from walmart
group by invoice_id
order by Total_Sales desc limit 5;


# Most Sold Category per Branch
with most_sales as (
	select
		Branch,
        category,
		sum(Price) as Total_Sales,
        rank() over (partition by branch order by sum(Price) desc) as rank_no
	from walmart
	group by Branch, category
)
select
*
from most_sales
where rank_no = 1;













