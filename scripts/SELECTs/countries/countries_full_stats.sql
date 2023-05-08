select
       country as "страна",
       count(elo) as "всего игроков",
       avg(elo) as "средний рейтинг",
       max(elo) as "максимальынй рейтинг",
min(elo) as "минимальный рейтинг"
from chess.player
group by country
order by avg(elo) DESC;
-- Сортировка стран по среднему рейтингу игроков