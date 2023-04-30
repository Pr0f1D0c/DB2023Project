-- COPY chess.opening (ECO, white, white, pgn) FROM '../../data/csv/opening.csv';

DELETE FROM chess.opening WHERE ECO='A98';  -- на случай, если A98 уже в csv
INSERT INTO chess.opening (ECO, white, black, pgn)
    VALUES ('A98', 'Dutch', 'Ilyin-Genevsky Variation with Qc2', '1. d4 f5 2. c4 Nf6 3. g3 e6 4. Bg2 Be7 5. Nf3 O-O 6. O-O d6 7. Nc3 Qe8 8. Qc2')