select * from customer_shopping_behavior;

select gender, sum(purchase_amount) as revenue
 from customer_shopping_behavior
 group by gender;
 
 select customer_id, purchase_amount
 from customer_shopping_behavior
 where discount_applied = 'yes' and purchase_amount>= (select avg (purchase_amount) from customer_shopping_behavior);
 
 select item_purchased , avg(review_rating)
 from customer_shopping_behavior
 group by item_purchased
 order by avg(review_rating) desc
 limit 5;

select shipping_type, avg(purchase_amount)
from customer_shopping_behavior
where shipping_type in ('Standard' and 'Express')
group by shipping_type;

select subscription_status, avg(purchase_amount), 
sum(purchase_amount) as total_revenue, count(customer_id)
from customer_shopping_behavior
group by subscription_status
order by total_revenue desc;

select item_purchased,
100 * sum(case when discount_applied ='yes' then 1 else 0 end )/count(*) as discount_rate
from customer_shopping_behavior
group by item_purchased
order by discount_rate desc
limit 5;


with customer_type as (
select customer_id, previous_purchases,
case 
	when previous_purchases = 1 then 'New'
    when previous_purchases between 2 and 10 then 'Returning'
    else 'Loyal'
    end as customer_segment
    from customer_shopping_behavior
    )
    
    select customer_segment, count(*)as No_of_customer
    from customer_type
    group by customer_segment;
    
    
   with item_count as (
   select category,
   item_purchased, 
   count (customer_id) as total_orders ,
   row_number() over(partition by category order by count(customer_id) desc) as item_rank
   from customer_shopping_behavior
   group by category, item_purchased
   )
   
   select item_rank, category, item_purchased, total_orders
   from item_count
   where item_rank <=3 ;
   
   select subscription_status,
   count(customer_id) as repeat_buyers
   from customer_shopping_behavior
   where previous_purchases>5
   group by subscription_status;
   
   
select age_group, sum(purchase_amount) as revenue
from customer_shopping_behavior
group by age_group
order by revenue desc;