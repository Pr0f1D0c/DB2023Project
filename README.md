# DB2023Project
## Аннотация 
В проекте разрабатывается база данных шахматных партий лучших игроков мира, подобная базам таких сайтов, как chess.com и chessbase.com. Реализация построена на СУБД PostgreSQL. 

## Описание сущностей
В базе данных хранится информация о следующих освновных сущностях:
- Записи шахматных партий,
- Информация о сильнейших шахматистиах, входящих в организацию FIDE.
- Шахматные дебюты и их вариации,
- Некоторые шахматные турниры.

### Партии (game)
Атрибуты:
- **id** - уникальный номер партии в базе данных,
- white - FIDE-индекс игрока за белых,
- black - FIDE-индекс игрока за черных,
- result - Строка, отражающая результат партии ("1-0" в случае победы белых, "0-1" в случае победы черных, "1/2-1/2" в случае ничьей)
- pgn - Запись партии в шахматной нотации pgn. Пример парии (Kasparov vs. Deep Blue Rematch):
`1.e4 c6 2.d4 d5 3.Nc3 dxe4 4.Nxe4 Nd7 5.Ng5 Ngf6 6.Bd3 e6 7.N1f3 h6
8.Nxe6 Qe7 9.O-O fxe6 10.Bg6+ Kd8 
11.Bf4 b5 12.a4 Bb7 13.Re1 Nd5 14.Bg3 Kc8 15.axb5 cxb5 16.Qd3 Bc6 
17.Bf5 exf5 18.Rxe7 Bxe7 19.c4 1-0`,
- opening - Индекс дебюта в международной системе ECO,
- variation - Название вариации дебюта,
- dt - Дата партии,
- tournament - название туринира, в рамках которого проходила партия, либо NULL.

### Игроки (player)
- **FIDE** - индекс игрока в международной системе организации ФИДЕ.
- ELO - рейтинг игрока по международной метрике ELO, используемой FIDE.
- full_name - имя шахматиста.
- last_update - дата последнего обновления рейтинга (подсчет производится ФИДЕ ежемесячно).
- title - Разряд шахматиста (GM - гроссмейстер, IM - международный мастер, FM - мастер FIDE, CM - кандидат в мастера).
- country - Код страны шахматиста (например, `RUS`).
- sex - Пол шахматиста (`M` / `W`).
- birthdate - дата рождения шахматиста.

### raiting_history
Дополнительная таблица с историей обновления рейтинга и разраядов игроков (выбран тип SCD 4).
- **FIDE** - Индекс игрока в международной системе организации ФИДЕ.
- **dt** - Дата обновления рейтинга.
- ELO - Рейтинг игрока по международной метрике ELO, используемой FIDE.
- delta - Изменение рейтинга за последний период.
- title - Разряд в момент расчета рейтинга.

### tournament
- **name** - Название турнира/события.
- year - Год события в формате числа.
- site - Место проведеняи события (например, Moscow RUS).
- winner - FIDE победителя соревнования.

### opening
- **ECO** - Индекс дебюта в международной системе ECO.
- name - Название дебюта (например, `Anderssen Opening`).
- color - Цвет, за которой играется дебют.
- pgn - Запись ходов дебюта в формате pgn.

### variation
Дополнительная таблица с вариациями дебютов
- **ECO** - Индекс дебюта в международной системе ECO.
- **variation** - название вариации дебюта (например, `Anderssen Opening, General`).
- pgn - Запись ходов в формате pgn.

Структура БД представлена в файле `logical-model.jpg`. Более общая концептуальная модель в файле `conceptual-model.jpg`.
