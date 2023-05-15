create view "card_no_operations" as
select
    t.id,
    a.nickname,
    t.dt,
    date_part('days', t.premium_duration) as "premium days",
    concat(left(t.card_number, 5), '****-****', right(t.card_number, 5)) as "card number"
from chess.premium_transaction t
left join chess.amateur a on a.id = t.player;

select * from "Card_no_operations";