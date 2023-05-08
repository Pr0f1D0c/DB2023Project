create or replace view player_most_common_opening as
with player_openings as (
    select white as player,
           opening,
           id,
           CASE result when '1-0' then 1 else 0 end as result
    from chess.game
    UNION ALL
    select black as player,
           opening,
           id,
           CASE result when '0-1' then 1 else 0 end as result
    from chess.game
),
player_most_common_opening as (
    select
        player,
        opening,
        count(result) as total,
        sum(result) as win,
        rank() over (partition by player order by sum(result) desc) as rank
    from player_openings
    group by player, opening
),
most_common as (
    select *
    from player_most_common_opening
    where rank = 1
)
select firstname, surname, mc.opening, op.white as "opening name", total, win
from chess.player
right join most_common mc on mc.player = fide
left join chess.opening op on mc.opening = op.eco
order by win desc;
-- "Любимый дебют каждого игрока. Выводит также число игр с этим дебютом, а также число побед.

select * from player_most_common_opening;