create or replace view "named_game" as
    select
        g.id as "game id",
        concat(left(w.firstname, 1), '. ', w.surname) as "white",
        concat(left(b.firstname, 1), '. ', b.surname) as "black",
        g.result,
        g.dt as "date"
    from chess.game as g
    left join chess.player w on w.fide = g.white
    left join chess.player b on b.fide = g.black;
-- Выводит список партий с датой, именами соперников и результатом.
-- Конкатенация строк и сокащение firstname можно считать
-- аналогом сокрытия информации (*****)

select * from named_game;