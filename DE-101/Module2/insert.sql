insert into practic.customer_dim(customer_id,customer_name,segment)
select o.customer_id,
		o.customer_name,
		o.segment
from public.orders o
group by o.customer_id,
		o.customer_name,
		o.segment
order by  o.customer_id,
		o.customer_name;
		
update public.orders
set postal_code = 212808
where postal_code is null;
	
insert into practic.geography_dim(country,city,state,postal_code)
select distinct o.country,
				o.city,
				o.state,
				o.postal_code
from public.orders o
group by o.country,
		o.city,
		o.state,
		o.postal_code
		
		
insert into practic.product_dim(category, sub_category, product_name, product_id)
select  o.category,
		o.subcategory,
		o.product_name,
		o.product_id
from public.orders o
group by o.category,
			o.subcategory,
			o.product_name,
			o.product_id;		
		
		
insert into practic.shipping_dim (ship_mode)
select  o.ship_mode
from public.orders o
group by o.ship_mode;


insert into practic.order_date_dim (order_date, "year", quarter,  week, "day")
select o.order_date, 
		extract (YEAR FROM o.order_date), 
		extract (QUARTER FROM o.order_date),
		extract ( WEEK FROM o.order_date),
		extract (day FROM o.order_date) 
from stg.orders o 
group by o.order_date,
		extract (YEAR FROM o.order_date),
		extract (QUARTER FROM o.order_date),
		extract ( WEEK FROM o.order_date),
		extract (day FROM o.order_date) 
order by o.order_date


insert into practic.ship_date_dim (ship_date, "year", quarter, manth, week, "day")
select o.ship_date, 
		extract (YEAR FROM o.ship_date), 
		extract (QUARTER FROM o.ship_date),
		extract (MONTH FROM o.ship_date),
		extract ( WEEK FROM o.ship_date),
		extract (day FROM o.ship_date) 
from stg.orders o 
group by o.ship_date, 
		extract (YEAR FROM o.ship_date),
		extract (QUARTER FROM o.ship_date),	
		extract (MONTH FROM o.ship_date), 
		extract ( WEEK FROM o.ship_date),
		extract (day FROM o.ship_date) 
order by o.ship_date

		


insert into practic.sales_fact(order_id,
							sales,
							quantity,
							discount,
							profit,
							returned,
							geographi_id,
							customer_id_dim,
							ship_id_dim,
							product_id_dim,
							ship_date_id,
							order_date_id_dim)
select distinct o.order_id,
				o.sales,
				o.quantity,
				o.discount,
				o.profit,
				r.returned,
				gd.geographi_id,
				cd.customer_id_dim,
				sd.ship_id_dim,
				pd.product_id_dim,
				sdd.ship_date_id,
				odd.order_date_id_dim
from stg.orders o

left join stg.returned r 
		on o.order_id = r.order_id
		
inner join practic.geography_dim gd 
		on o."State" = gd.state and o.city = gd.city and o.postal_code = gd.postal_code
inner join practic.customer_dim cd 
		on o.customer_id = cd.customer_id
inner join practic.shipping_dim sd 
		on o.ship_mode = sd.ship_mode
inner join practic.product_dim pd 
		on o.product_id = pd.product_id
inner join practic.ship_date_dim sdd   
		on o.ship_date = sdd.ship_date 
inner join practic.order_date_dim odd  
		on o.order_date = odd.order_date 
