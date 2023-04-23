-- COPY chess.game (id, white, black, opening, dt, tournament)
--     FROM '../../data/csv/game.csv';

INSERT INTO chess.game(id, white, black, result, opening, dt, tournament)
VALUES (199999998,
        (select fide from chess.player where surname='Blue' and firstname='Deep'),
        (select fide from chess.player where surname='Kasparov' and firstname='Garry'),
        '1-0',
        'B22',
        '1996.02.10',
        null
        );
-- Первая победа от Deep Blue

INSERT INTO chess.game(id, white, black, result, opening, dt, tournament)
VALUES (199999999,
        (select fide from chess.player where surname='Kasparov' and firstname='Garry'),
        (select fide from chess.player where surname='Blue' and firstname='Deep'),
        '1-0',
        'E04',
        '1996.02.11',
        null
        );
-- Реванш Каспарова