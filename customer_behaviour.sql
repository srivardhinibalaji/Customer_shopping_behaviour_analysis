show databases;
use customer_behaviour;
show tables;
select * from customers;

# total revenue by male vs female?
select gender, sum(purchase_amount) as revenue from customers
group by gender;

# customers who used discount & purchased more than average of purchase amount?
select customer_id, purchase_amount from customers
where discount_applied = "Yes" and purchase_amount >= (select avg(purchase_amount) from customers);

# top 5 products with highest average review rating?
select item_purchased, round(avg(review_rating),2) as avg_prod_rating from customers
group by item_purchased
order by avg_prod_rating desc
limit 5;

# compare average purchase amounts between standard and express shipping?
select shipping_type, round(avg(purchase_amount),2) as avg_purchase_amount from customers
where shipping_type in ("Express", "Standard")
group by shipping_type;

# compare average spend and total revenue between subscribers and non-subscribers?
select subscription_status, count(customer_id) as customer_count, round(avg(purchase_amount),2) as avg_spend, round(sum(purchase_amount),2) as tot_revenue from customers
group by subscription_status
order by tot_revenue, avg_spend desc;

# top 5 products with highest percentage of purchases?
select item_purchased, round(100 * sum(case when discount_applied="Yes" then 1 else 0 end)/count(*),2) as discount_rate from customers
group by item_purchased
order by discount_rate desc
limit 5;

# Count of customer segments (New, Returning and Loyal) based on previous purchases?
with customer_type as (select customer_id, previous_purchases, 
case
  when previous_purchases=1 then "New"
  when previous_purchases between 2 and 10 then "Returning"
  else "Loyal"
end as customer_segment
from customers)
select customer_segment, count(*) as "Number of customers" from customer_type
group by customer_segment;

# top 3 most purchased products within each category?
with cte as (select category, item_purchased, count(customer_id) as tot_orders, row_number() over(partition by category order by count(customer_id) desc) as item_rank from customers
group by category, item_purchased)

select item_rank, category, item_purchased, tot_orders from cte
where item_rank<=3;

# are customers who are repeat buyers (>5 previous purchases) likely to be subscribers?
select subscription_status, count(customer_id) as repeat_buyers from customers
where previous_purchases > 5
group by subscription_status;

# total revenue by age group
select age_group, sum(purchase_amount) as tot_revenue_by_agegroup from customers
group by age_group
order by tot_revenue_by_agegroup desc;



