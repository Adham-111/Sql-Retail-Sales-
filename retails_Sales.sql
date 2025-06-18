--data cleaning--
select * from dbo.Sales; 
select count (*) from dbo.Sales;
select * from dbo.Sales
where transactions_id is null ;
--check null columns--
select * from dbo.sales 
where transactions_id is null
			or
			sale_date is null 
			or
			sale_time is null 
			or 
			customer_id is null 
			or 
			gender is null
			or
			age is null 
			or
			category is null 
			or
			quantiy is null 
			or
			price_per_unit is null 
			or
			cogs is null 
			or 
			total_sale is null  ;
--delete null values in quantiy and price_per_unit"3 rows "
delete  from Sales 
where
			quantiy is null 
			and
			price_per_unit is null 
			and
			cogs is null 
			and 
			total_sale is null
--Replace null in age coulmn by average age --
update Sales
set age = (select AVG(age) from Sales)
where age is null ; 
--data exploration -- 
--number of total sales --
select count (*) from dbo.Sales;
--number of customers-- 
select count(distinct customer_id) from dbo.Sales;
--number of category and name-- 
select count(distinct category) from dbo.Sales;
select distinct category from dbo.Sales
-- Data anlaysis & bussiness key problems & Answers --
 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05 
 select * from dbo.[Sales ]
 where sale_date = '2022-11-05 ' ;
 -- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
 SELECT *
FROM dbo.[Sales ]
WHERE
    FORMAT(sale_date, 'yyyy-MM') = '2022-11'
    AND category = 'clothing'
    AND quantiy>= 4;
	--Write a SQL query to calculate the total sales (total_sale) for each category
	select category ,sum(total_sale) as totalCategory_sales ,count (*) as totalorders 
	from dbo.Sales 
	group by category ;
	--- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
	select AVG(age) as average_Age
	from dbo.[Sales ]
	where category = 'Beauty' ; 
	---- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
	select * from dbo.[Sales ] 
	where total_sale > 1000 ;
	-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
	select category,gender , count(transactions_id) as number_transactions 
	from dbo.[Sales ]
	group by category  , gender ;
	-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
	select * from (
	select year(sale_date) as Yearcoulmn , month(sale_date) as monthcoulmn,
	Round(avg (total_sale),2) as averagTotalsales , rank() over(partition by year(sale_date) order by Round(avg (total_sale),2) desc ) as rank
	from dbo.Sales 
	group by  year(sale_date) , month(sale_date) 
	) as t1 
	where rank = 1 ;
	-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
	select top 5 customer_id ,sum(total_sale) as total_sales
	from dbo.[Sales ] 
	group by customer_id 
	order by 2 desc;
	-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
	select count (distinct customer_id) as number_unique_customers, category 
	from dbo.[Sales ] 
	group by category ;
	-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
	with hoursSALES
	as (
	select *, 
	case  
		when datepart(HOUR,sale_time) < 12 then 'morning' 
		when datepart(HOUR,sale_time) between 12
		   and 17 then 'Afternoon' else 'evening'
		   end as Shift 
		   from dbo.[Sales ] 
		   )
 select shift , count(*) as number_orders
 from hoursSALES 
 group by shift ;
--end project --