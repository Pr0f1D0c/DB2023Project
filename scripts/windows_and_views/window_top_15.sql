create or replace view top_15_players as
select
       rank() over (order by elo DESC),
       *
from chess.player
limit 15;
-- Топ 15 сильнейших шахматистов мира

select * from top_15_players;