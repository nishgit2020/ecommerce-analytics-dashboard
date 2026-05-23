-- KPI 1: total payment
select sum(total_payments) from order_payments_agg;

-- KPI 2: count of orders
select count(order_id) from orders;

-- KPI 3: uniques customer count
select count(distinct customer_unique_id) from customers;

-- KPI 4: average order value
select round(sum(total_payments)/count(distinct orders.order_id),2) from orders 
left join order_payments_agg
on orders.order_id = order_payments_agg.order_id;

-- chart 1 - monthly revenue trend
select sum(p.total_payments) as total_payment,date_format(o.order_purchase_timestamp,'%Y-%m') as 'year_month' 
from order_payments_agg as p
inner join orders as o on p.order_id = o.order_id 
group by date_format(order_purchase_timestamp,'%Y-%m')
order by date_format(order_purchase_timestamp,'%Y-%m');

-- chart 2: top product category by revenue
SELECT 
    t.product_category_name_english AS category_name,
    SUM(opagg.total_payments) AS total_payment
FROM order_items oi
INNER JOIN order_payments_agg opagg 
    ON oi.order_id = opagg.order_id
INNER JOIN products p 
    ON oi.product_id = p.product_id
INNER JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
ORDER BY total_payment DESC
LIMIT 10;

-- chart 3: sales by customer state
with total_payment_temp as
(
	select order_id,sum(total_payments) as pay from order_payments_agg
	group by order_id order by sum(total_payments) desc
)
select customer_state,sum(pay) from orders 
inner join customers on orders.customer_id = customers.customer_id
inner join total_payment_temp on total_payment_temp.order_id = orders.order_id
group by customer_state 
order by sum(pay) desc
limit 10;

-- chart 4: top seller cities by revenue
select seller_city, sum(price) from order_items 
inner join sellers on order_items.seller_id = sellers.seller_id
group by seller_city
order by sum(price) desc
limit 10;

-- chart 5: order status distribution
select order_status, concat(round((count(order_status)/ (select count(distinct order_id) from orders))*100,2),"%")
as percentage from orders group by order_status;

