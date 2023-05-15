create index "chess.player.country"
    on chess.player
    using btree
    (country);
-- Использовано B-дерево, так как уникальных значений (стран) немного -> bitmap не нужен

create index "chess.player.elo"
    on chess.player
    using btree
    (elo);
-- Часто нужно фильтровать по граничным значениям рейтинга -> B-дерево оптимальный - выбор

create index "chess.game.white"
    on chess.game
    using btree
    (white);
create index "chess.game.black"
    on chess.game
    using btree
    (black);
-- Чаще всего нужно искать по игрокам, участвовывшим в партии -> B-tree

create index "chess.amateur_game.white"
    on chess.amateur_game
    using btree
    (white);
create index "chess.amateur_game.black"
    on chess.amateur_game
    using btree
    (black);
-- same