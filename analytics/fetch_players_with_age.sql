select *,
       date_part('year', current_date)::int - birthdate as age
from chess.player
where birthdate <> 0