drop table if exists zepto

create table zepto(
sku_id SERIAL PRIMARY KEY,
category varchar(120),
name varchar(150) not null,
mrp numeric(8,2),
discountPercent numeric(5,2),
availableQuantity integer,
discountedSellingPrice numeric(8,2),
weightInGms integer,
outOfStock boolean,
quantity integer
)


--- Data Exploaration

--- Sample data 
select * from zepto

--- count of rows
select count(*) from zepto

--- first 10 records
select * from zepto
limit 10 

--- checking null values
select * from zepto 
where name is null
or
category is null
or
mrp is null
or
discountpercent is null
or
availablequantity is null
or
discountedsellingprice is null
or
weightingms is null
or
outofstock is null
or
quantity is null

--- different product categories
select distinct(category) from zepto
order by category

--- products instock vs outstock
select outofstock,count(sku_id) from zepto
group by outofstock

--- product names present multiple times
select name,count(sku_id) as "No_of_SKU'S"
from zepto
group by name
having count(sku_id)>1
order by count(sku_id) desc

--- data cleaning

--- products with price=0
select name,category from zepto
where mrp=0

delete from zepto
where mrp=0

--- convert paise to rupee
update zepto
set mrp=mrp/100.0,
discountedsellingprice=discountedsellingprice/100.0

--- BUSINESS INSIGHTS
--- 1.Find the top 10 best-value products based on the discount percentage.
select distinct name,mrp,discountpercent from zepto
order by discountpercent desc limit 10

--- 2.What are the products with high MRP but outofstock.
select distinct name,mrp from zepto
where outofstock=true and mrp>300
order by mrp desc

--- 3.Calculate estimated revenue for each category.
select distinct category,sum(discountedsellingprice*availablequantity) as total_revenue from zepto
group by category
order by total_revenue 

--- 4.Find all products where MRP is greater than 500/- and discount is less than 10%.
select distinct name,mrp,discountpercent from zepto
where mrp>500.0 and discountpercent<10
order by mrp desc

--- 5.Identify the top 5 categories offering the highest average discount percentage.
select category,round(avg(discountpercent),2) as average_discount from zepto
group by category
order by average_discount desc limit 5

--- 6.Find the price per gram for products above 100g and sort by best value.
select distinct name,weightingms,discountedsellingprice,
round(discountedsellingprice/weightingms,2)as price_per_gram
from zepto
where weightingms>=100
order by price_per_gram 

--- 7.Group the products into categories like Low,Medium,Bulk.
select distinct name,weightingms,
case 
    when weightingms<500 then 'Low'
    when weightingms<1000 then 'Medium'
	else 'Bulk'
	end as weight_category
from zepto

--- 8.What is the total inventory weight per category
select category,sum(weightingms*availablequantity)as total_weight 
from zepto
group by category
order by total_weight

