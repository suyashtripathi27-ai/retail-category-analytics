-- Query 1: Revenue by category
select
category_name_translation.product_category_name_english,
SUM(order_items_dataset.price) as total_revenue
FROM order_items_dataset
JOIN products_dataset
ON order_items_dataset.product_id=products_dataset.product_id
join category_name_translation 
ON products_dataset.product_category_name=category_name_translation.product_category_name
group by category_name_translation.product_category_name_english;

-- Query 2: Delivery delay by category
select
order_items_dataset.order_id,
EXTRACT(EPOCH FROM (orders_dataset.order_delivered_customer_date - orders_dataset.order_estimated_delivery_date)) / 86400 AS delay_days
from order_items_dataset
join orders_dataset 
on  orders_dataset.order_id = order_items_dataset.order_id 
limit 10;

--Query 3: Product Category Name by product 
select
products_dataset.product_id,
products_dataset.product_category_name
from products_dataset 
join category_name_translation 
on products_dataset.product_category_name  = category_name_translation.product_category_name
limit 10;

-- Query 4: Average delivery delay by category
select 
category_name_translation.product_category_name_english,
AVG (EXTRACT(EPOCH FROM (orders_dataset.order_delivered_customer_date - orders_dataset.order_estimated_delivery_date)) / 86400) AS delay_days
from order_items_dataset
join orders_dataset
on orders_dataset.order_id = order_items_dataset.order_id
join products_dataset
on order_items_dataset.product_id = products_dataset.product_id
join category_name_translation
on products_dataset.product_category_name = category_name_translation.product_category_name
group by category_name_translation.product_category_name_english;

-- Query 5: Revenue and Average delivery delay by category
WITH revenue_by_category AS (
select
category_name_translation.product_category_name_english,
SUM(order_items_dataset.price) as total_revenue
FROM order_items_dataset
JOIN products_dataset
ON order_items_dataset.product_id=products_dataset.product_id
join category_name_translation 
ON products_dataset.product_category_name=category_name_translation.product_category_name
group by category_name_translation.product_category_name_english
),
delay_by_category AS (
select 
category_name_translation.product_category_name_english,
AVG (EXTRACT(EPOCH FROM (orders_dataset.order_delivered_customer_date - orders_dataset.order_estimated_delivery_date)) / 86400) AS delay_days
from order_items_dataset
join orders_dataset
on orders_dataset.order_id = order_items_dataset.order_id
join products_dataset
on order_items_dataset.product_id = products_dataset.product_id
join category_name_translation
on products_dataset.product_category_name = category_name_translation.product_category_name
WHERE orders_dataset.order_delivered_customer_date IS NOT null
group by category_name_translation.product_category_name_english
)
SELECT
    revenue_by_category.product_category_name_english,
    revenue_by_category.total_revenue,
    delay_by_category.delay_days
FROM revenue_by_category
JOIN delay_by_category
    ON revenue_by_category.product_category_name_english = delay_by_category.product_category_name_english;

-- Query 6: Average delivery delay by seller
select 
sellers_dataset.seller_id,
AVG (EXTRACT(EPOCH FROM (orders_dataset.order_delivered_customer_date - orders_dataset.order_estimated_delivery_date)) / 86400) AS delay_days,
COUNT (product_id) as number_product_delivered_by_seller
from orders_dataset
join order_items_dataset
on orders_dataset.order_id = order_items_dataset.order_id
join sellers_dataset
on order_items_dataset.seller_id = sellers_dataset.seller_id
WHERE orders_dataset.order_delivered_customer_date IS NOT null
group by sellers_dataset.seller_id
having count (product_id) > 500;

-- Query 7: Average delivery delay by review score
select 
order_reviews_dataset.review_score,
AVG (EXTRACT(EPOCH FROM (orders_dataset.order_delivered_customer_date - orders_dataset.order_estimated_delivery_date)) / 86400) AS delay_days,
COUNT (review_score) as number_of_review_by_customer
from orders_dataset
join order_reviews_dataset
on orders_dataset.order_id = order_reviews_dataset.order_id
WHERE orders_dataset.order_delivered_customer_date IS NOT null
group by order_reviews_dataset.review_score
having count (review_score) > 3;
