select country,
       count(elo) as "всего игроков",
       round(avg(elo)) as "средний рейтинг",
       max(elo) as "максимальынй рейтинг"
from chess.player
where elo > 1000
group by country
order by count(elo) DESC;
-- Сортировка стран по числу игроков с рейтингом более 1000