select count(*) as total_orders,month(ecommerce.orders.order_purchase_timestamp) as order_month
from orders where year(ecommerce.orders.order_purchase_timestamp) = 2018 
group by month(ecommerce.orders.order_purchase_timestamp) ORDER BY order_month;

select * from ecommerce.orders;

select customer_id, order_purchase_timestamp,payments,
avg(payments) over (partition by customer_id order by order_purchase_timestamp
rows between 2 preceding and current row) as moving_avg from
(select orders.customer_id, orders.order_purchase_timestamp, 
payments.payment_value as payments from orders join 
payments on payments.order_id = orders.order_id) as a;



select years,months,payments,sum(payments) over (order by years,months) as cummulative_sales from
(select year(orders.order_purchase_timestamp) as years, 
month(orders.order_purchase_timestamp) as months, 
round(sum(payments.payment_value),2) as payments from orders 
join payments on orders.order_id = payments .order_id
group by years, months order by years,months) as a;


select year(orders.order_purchase_timestamp) as years,  
round(sum(payments.payment_value),2) as payments from orders 
join payments on orders.order_id = payments .order_id
group by years order by years

with a as (select customers.customer_id, min(orders.order_purchase_timestamp) as first_order
from customers join orders on 
customers.customer_id = orders.customer_id group by customers.customer_id),
b as (select a.customer_id, count(distinct(orders.order_purchase_timestamp)) as next_order
from a join orders on orders.customer_id = a.customer_id 
and orders.order_purchase_timestamp > first_order
and orders.order_purchase_timestamp < date_add(first_order,interval 6 month)
group by a.customer_id)
select 100* (count(distinct a.customer_id)/count(distinct b.customer_id))
from a left join b on a.customer_id = b.customer_id;

select years, customer_id,payment,d_rank from
(select year(orders.order_purchase_timestamp) years,orders.customer_id, 
sum(payments.payment_value) as payment,
dense_rank() over ( partition by year(orders.order_purchase_timestamp) 
order by sum(payments.payment_value) desc) as d_rank
from orders join payments on payments.order_id = orders.order_id 
group by year(orders.order_purchase_timestamp),orders.customer_id,orders.order_id) as a
where d_rank <=3;