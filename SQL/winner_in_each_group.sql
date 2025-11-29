with cte as (
select *,
case 
	when first_score > second_score then first_player 
	when first_score = second_score and first_player<second_player then first_player
	else second_player 
end as winner_id,
case 	
	when first_score > second_score then first_score
	else second_score 	
end as winner_score
from matches),
winners as (
select winner_id,winner_score, group_id, rank() over (partition by group_id order by winner_score desc) as rnk
from cte
join players
on cte.winner_id = players.player_id)
select group_id, winner_id as player_id, winner_score as score
from winners where rnk=1
