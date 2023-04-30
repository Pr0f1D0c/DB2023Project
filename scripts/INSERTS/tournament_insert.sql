-- COPY chess.tournament (id, name, year, site)
--     from '../../data/csv/tournament.csv';

SELECT setval('chess.tournament_id_seq', (SELECT MAX(id) FROM chess.tournament) + 1);

INSERT INTO chess.tournament (name, year, site)
    VALUES ('FIDE Women''s Grand Prix' , 2023, 'Nicosia, Cyprus');