-- Complex level queries
--16.Determine the percentage chance of receiving 
-- warranty claims after each purchase for each country.

select country, total_units_sold, total_claims,
coalesce(round((total_claims :: numeric/total_units_sold :: numeric * 100),2),0) as warranty_percentage
from (select st.country, sum(s.quantity) as total_units_sold,
count(w.claim_id) as total_claims
from sales s join warranty w on s.sale_id = w.sale_id
left join stores st on s.stored_id = st.stored_id group by st.country) t1
order by warranty_percentage desc;


--17.Analyze the year-by-year growth ratio for each store.
with yearly_sales as
(select s.stored_id,extract (year from sale_date) as sale_year,st.store_name,
sum(quantity*price) as total_sale_price from sales s join products p on p.product_id = s.product_id
join stores st on s.stored_id = st.stored_id group by s.stored_id, sale_year,st.store_name
order by st.store_name, total_sale_price),growth_ratio as(
select store_name,sale_year, 
lag(total_sale_price,1) over (partition by store_name order by sale_year) as last_year_sale,
total_sale_price as current_year_sale from yearly_sales) 
select store_name, sale_year, last_year_sale, current_year_sale, 
round((current_year_sale - last_year_sale) :: numeric / last_year_sale :: numeric * 100,2) as growth_ratio
from growth_ratio where last_year_sale is not null 
and sale_year <> extract(year from current_date);


--18.Calculate the correlation between product price 
-- and warranty claims for products sold in the 
-- last five years, segmented by price range.

select CASE 
when p.price<500 then 'Less Expensive Product'
when p.price >=500 and p.price<1000 then 'Mid-Range Product'
else 'Expensive Product' end as price_segment, count(w.claim_id) as total_claim
from warranty w left join sales s on s.sale_id = w.sale_id
join products p on s.product_id = p.product_id
where w.claim_date > current_date - interval '5 years'
group by price_segment order by total_claim; 


--19.Identify the store with the highest percentage of "Paid Repaired" 
-- claims relative to total claims filed.

with completed_repair as (
select s.stored_id, count(w.claim_id) as total_completed_repair from sales s 
right join warranty w on s.sale_id = w.sale_id 
where w.repair_status = 'Completed' group by s.stored_id),
total_repaired as(
select s.stored_id, count(w.claim_id) as total_repair from sales s 
right join warranty w on s.sale_id = w.sale_id group by s.stored_id)
select total_repaired.stored_id,st.store_name, completed_repair.total_completed_repair, 
total_repaired.total_repair, 
round((total_completed_repair :: numeric)/(total_repair::numeric) * 100,2) as repaired_percentage
from completed_repair join total_repaired on 
completed_repair.stored_id = total_repaired.stored_id
join stores as st on total_repaired.stored_id = st.stored_id order by repaired_percentage desc;


--20.Write a query to calculate the monthly running total 
-- of sales for each store over the past four years 
-- and compare trends during this period.

with monthly_sales as(
select stored_id, extract (year from sale_date) as year_no, 
extract(month from sale_date) as month_no,sum(p.price*s.quantity) as tot_rev
from sales s join products p on
s.product_id = p.product_id group by stored_id, year_no, month_no
order by stored_id, year_no,month_no)
select stored_id, year_no,month_no,tot_rev, 
sum(tot_rev) over (partition by stored_id order by year_no,month_no) as running_total
from monthly_sales;



-- Bonus Question
-- Analyze product sales trends over time, segmented into key periods: 
-- from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months.
select p.product_name,case
when s.sale_date between p.launch_date and p.launch_date + interval '6 months' then '0-6 month'
when s.sale_date between p.launch_date + interval '6 months' and p.launch_date + interval '12 months' then '6-12 month'
when s.sale_date between p.launch_date + interval '12 months' and p.launch_date + interval '18 months' then '12-18 month'
else 'Beyond 18 month' end as plc,sum(s.quantity) as total_qty_sale
from sales s join products p on s.product_id = p.product_id
group by product_name,plc order by p.product_name, plc desc;


