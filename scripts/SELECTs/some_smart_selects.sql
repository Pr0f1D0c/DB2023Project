select pl.fide, pl.surname || ' ' || pl.firstname as name,
       pl.elo as new_elo, rh.elo as old_elo,
       pl.title as new_title, rh.title as new_title
from chess.rating_history rh
left join chess.player pl on pl.fide = rh.fide
where pl.elo <> rh.elo
order by name
-- Выводит всех игроков, у которых изменялись рейтинги,
-- что отражено в таблице изменения рейтинга