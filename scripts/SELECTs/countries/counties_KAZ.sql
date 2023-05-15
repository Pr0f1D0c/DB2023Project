select * from chess.player
         where country = 'KAZ' and
               elo = (select max(elo) from chess.player where country = 'KAZ')
-- Сильнейший игрок Казахстана