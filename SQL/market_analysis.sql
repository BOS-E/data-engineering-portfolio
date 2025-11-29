-- Write an SQL query to find for each seller whether the brand of the second item (by date) they sold is their favorite brand. If a seller sold less than two items, output No.

with 
cte as (
	select order_date, item_id, seller_id,
	row_number() over (partition by seller_id order by order_date) as rn
	from orders), 
cte2 as (
	select order_date, item_id, seller_id from cte where rn=2),
cte3 as (
	select cte2.*, favorite_brand, item_brand from cte2 
	join users on cte2.seller_id = users.user_id
	join items on cte2.item_id = items.item_id)
select users.user_id as seller_id,
	case when cte3.favorite_brand=cte3.item_brand then 'Yes' else 'No' end as item_fav_brand
from cte3 
right join users on cte3.seller_id=users.user_id 
order by user_id


