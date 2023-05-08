create or replace view opening_win_probability as
with win_count as (
    select opening, result, count(result) as cnt from chess.game
    group by opening, result
),
win_probability as (
    select
        eco,
        op.white as name,
        white.cnt as white,
        black.cnt as black,
        draw.cnt as draw,
        white.cnt + black.cnt + draw.cnt as total
    from chess.opening op
    left join win_count white on op.eco = white.opening and white.result = '1-0'
    left join win_count black on white.opening = black.opening and black.result = '0-1'
    left join win_count draw on draw.opening = black.opening and draw.result = '1/2-1/2'
)
select *,
       round(white::numeric / total * 100, 2) as "white prob, %",
       round(black::numeric / total * 100, 2) as "black prob, %",
       round(draw::numeric / total * 100, 2) as "draw prob, %"
from win_probability;

select * from opening_win_probability;
-- Вероятности побед сторон при разыгрывании дебютов.