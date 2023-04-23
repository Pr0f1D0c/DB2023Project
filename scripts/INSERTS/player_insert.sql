-- COPY chess.player (fide, firstname, surname, country, sex, birthdate, title, elo)
--     FROM '/home/profidoc/Courses/DB4sem/Project/DB2023Project/data/csv/player.csv';

DELETE from chess.player WHERE fide=12501000;  -- на случай, если уже в csv
INSERT INTO chess.player (fide, firstname, surname, country, sex, birthdate, title, elo)
    VALUES (12501000, 'Hasan' , 'Abbasifar', 'IRI', 'M', 1972, 'GM', 2265);

INSERT INTO chess.player (fide, firstname, surname, country, sex, birthdate, title, elo)
    VALUES (19999999, 'Deep' , 'Blue', 'IBM', 'M', 1995, '  ', 0);
-- The Deep Blue chess computer by IBM