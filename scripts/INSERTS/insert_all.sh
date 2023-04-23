#!/bin/sh
psql -h localhost -p 5432 -U postgres -d project --password <<OMG
begin;
\i ../tabels_creation_DDL.sql
\i ../triggers/premium_insert_trigger.sql
\i ../triggers/update_player_rating_trigger.sql

\copy chess.player from '../../data/csv/player.csv' DELIMITER ',' CSV HEADER;
\copy chess.opening from '../../data/csv/opening.csv' DELIMITER ',' CSV HEADER;
\copy chess.tournament from '../../data/csv/tournament.csv' DELIMITER ',' CSV HEADER;
\copy chess.game from '../../data/csv/game.csv' DELIMITER ',' CSV HEADER;

\i ./player_insert.sql
\i ./openings_insert.sql
\i ./tournament_insert.sql
\i ./game_insert.sql
\i ./update_player_history.sql

\i ./amateur_insert.sql
\i ./premium_transaction_insert.sql
\i ./amateur_game_insert.sql

commit;
OMG

#eof