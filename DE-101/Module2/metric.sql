
select sum(sales) total_sales from orders o 

select sum(profit) total_profit from orders o 

select order_id, ((profit/sales)*100) as ros from orders o 


select 
o.order_id,
sum(profit) 
from orders o 
group by  o.order_id 

select 
o.customer_id,  
sum (sales)
from orders o 
group by o.customer_id 

select avg(discount)  from orders o 

select distinct   
date_part('month',o.order_date), 
sum(o.sales), 
segment  
from orders o 
group by date_part('month',o.order_date), segment  
order by date_part('month',o.order_date)

select distinct   
date_part('month',o.order_date), 
sum(o.sales), 
category  
from orders o 
group by date_part('month',o.order_date), category  
order by date_part('month',o.order_date)





select sum(sales), category from orders o group by category 

select customer_id,   sum(sales), sum(profit)  from orders o group by customer_id  

select sum(sales), region  from orders o 
group by region 

