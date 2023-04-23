#!/bin/sh
psql -h localhost -p 5432 -U postgres -d project --password <<OMG
begin;
\i ../tabels_creation_DDL.sql

\copy chess.player from '../../data/csv/player.csv' DELIMITER ',' CSV HEADER;
\copy chess.opening from '../../data/csv/opening.csv' DELIMITER ',' CSV HEADER;
\copy chess.tournament from '../../data/csv/tournament.csv' DELIMITER ',' CSV HEADER;
\copy chess.game from '../../data/csv/game.csv' DELIMITER ',' CSV HEADER;

\i ./player_insert.sql
\i ./openings_insert.sql
\i ./tournament_insert.sql
\i ./game_insert.sql
commit;
OMG

#eof