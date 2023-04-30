-- update players
UPDATE chess.player
    SET elo = 2415, title = 'GM'
    WHERE fide = '14103400';

UPDATE chess.player
    SET elo = 2087, title = 'CM'
    WHERE fide = '24239305';

UPDATE chess.player
    SET elo = 2125, title = 'WFM'
    WHERE fide = '4134982';

UPDATE chess.player
SET elo = 2489, title = 'GM' -- Alberto Andres Gonzalez
WHERE fide = '2212595';

UPDATE chess.player
SET elo = 2278 -- Handszar Odeev
WHERE fide = '14000091';

UPDATE chess.player
SET elo = 2260 -- Gerhard Kiefer
WHERE fide = '4606965';

UPDATE chess.player
SET elo = 2070 -- Jobst Rueberg
WHERE fide = '4677501';

UPDATE chess.player
SET elo = 2113 -- Halim Turaev
WHERE fide = '14201399';

UPDATE chess.player
SET elo = 2387 -- Alexander Fishbein
WHERE fide = '2000377';

UPDATE chess.player
SET elo = 2618, title = 'GM' -- Anatoly Karpov
WHERE fide = '4100026';