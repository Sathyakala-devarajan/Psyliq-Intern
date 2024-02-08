-- Create database
create database Pharma_Data_analysis;
use Pharma_Data_analysis;

select * from pharma;

/* 1. Retrieve all columns for all records in the dataset */
select * from pharma;
 
/* 2. How many unique countries are represented in the dataset? */
select distinct Country from pharma;
 
/* 3. Select the names of all the customers on the 'Retail' channel. */
select distinct Customer_Name from pharma
where Sub_channel ='Retail';

/* 4. Find the total quantity sold for the 'Antibiotics' product class. */
select sum(Quantity) as 'Total quantity sold' from pharma
where Product_Class = 'Antibiotics';

/* 5. List all the distinct months present in the dataset. */
select distinct month from pharma;

/* 6. Calculate the total sales for each year.  */
select Year, sum(sales) as 'Total sales'
from pharma
group by year;

/* 7. Find the customer with the highest sales value. */
select Customer_Name, sum(sales) as 'Highest sales' 
from pharma
group by Customer_Name
order by sum(sales) desc
limit 1;

/* 8. Get the names of all employees who are Sales Reps and are managed by 'James Goodwill'. */
select Name_of_Sales_Rep from pharma
where Manager = 'James Goodwill';

/* 9. Retrieve the top 5 cities with the highest sales. */
select city, sum(sales) as 'Highest sales'
from pharma
group by city
order by sum(sales) desc
limit 5;

/* 10. Calculate the average price of products in each sub-channel. */
select sub_channel, round(avg(price),2) as 'Avg. Price'
from pharma
group by sub_channel;

/* 11. Join the 'Employees' table with the 'Sales' table to get the name of the Sales Rep and the corresponding sales records. */
select Name_of_Sales_Rep, sum(sales) as 'Total sales'
from pharma
group by Name_of_Sales_Rep;

/* 12. Retrieve all sales made by employees from 'Rendsburg' in the year 2020. */
select * from pharma
where city = 'Rendsburg' and year = 2020;

/* 13. Calculate the total sales for each product class, for each month, and order the results by year, month, and product class. */
select Product_Class, month, year, sum(sales) as 'Total sales'
from pharma
group by Product_Class, month, year;

/* 14. Find the top 3 sales reps with the highest sales in 2023. */
select Name_of_Sales_Rep, sum(sales) as 'Highest sales'
from pharma
group by Name_of_Sales_Rep
order by sum(sales) desc
limit 3;

/* 15. Calculate the monthly total sales for each sub-channel, and then calculate the average monthly sales for each sub-channel over the years. */
select sub_channel, year, sum(sales) as 'Total sales', avg(sum(sales)) over (partition by sub_channel) as 'Avg sales' 
from pharma
group by sub_channel, year;

/* 16. Create a summary report that includes the total sales, average price, and total quantity sold for each product class. */
select Product_class, 
	sum(sales) as 'Total sales',
    round(avg(price),2) as 'Average price',
    sum(Quantity) as 'Total quantity'
from pharma
group by product_class;

/* 17. Find the top 5 customers with the highest sales for each year. */
with rankcte as 
	(
	select dense_rank() over (partition by year order by sum(sales) desc) as sales_rank, 
		Customer_Name, year, sum(sales) as Total_sales
    from pharma
    group by Customer_Name, year    
	)
	select rankcte.Customer_Name, rankcte.year, rankcte.Total_sales
	from rankcte
	where sales_rank <= 5;

/* 18. Calculate the year-over-year growth in sales for each country. */
with cte as (
	select country, year, sum(sales) as Total_sales
	from pharma
	group by country, year
    )
	select cte.country, cte.year, cte.Total_sales,
		lag(Total_sales) over (partition by country order by year) as Previous_year_sales,
        (Total_sales - lag(Total_sales) over (partition by country order by year)) / (lag(Total_sales) over (partition by country order by year)) * 100 as YOY_growth
	from cte
    order by cte.country, cte.year;
        
/* 19. List the months with the lowest sales for each year . */
with cte as (
	select dense_rank() over (partition by year order by sum(sales)) as ranking, sum(sales) as Total_sales, month, year
	from pharma
	group by month, year
	order by year
    )
    select cte.month, cte.year, cte.Total_sales
    from cte
    where cte.ranking = 1;

/* 20. Calculate the total sales for each sub-channel in each country, and then find the country with the highest total sales for each sub-channel. */
with cte1 as (
	select rank() over (partition by Sub_channel order by sum(sales)) as ranking, 
		sum(sales) as Total_sales, country, Sub_channel
	from pharma
	group by country, Sub_channel
	order by Sub_channel
	)
	select cte1.country, cte1.Sub_channel, cte1.Total_sales
	from cte1
	where cte1.ranking = 1;