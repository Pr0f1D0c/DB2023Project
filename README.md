# DB2023Project
## Аннотация 
В проекте разрабатывается база данных шахматных партий лучших игроков мира, подобная базам таких сайтов, как chess.com и chessbase.com. Реализация построена на СУБД PostgreSQL. 

## Описание сущностей
В базе данных хранится информация о следующих освновных сущностях:
- Записи шахматных партий,
- Информация о сильнейших шахматистиах, входящих в организацию FIDE.
- Шахматные дебюты и их вариации,
- Некоторые шахматные турниры,
- Информация об игроках-любителях,
- Информация о любительских партиях,
- Информация о платежных транзакциях для покупки премиум-статуса игроками-любителями.

### Игроки (player)
- **FIDE** - индекс игрока в международной системе организации ФИДЕ.
- ELO - рейтинг игрока по международной метрике ELO, используемой FIDE.
- full_name - имя шахматиста.
- last_update - дата последнего обновления рейтинга (подсчет производится ФИДЕ ежемесячно).
- title - Разряд шахматиста (GM - гроссмейстер, IM - международный мастер, FM - мастер FIDE, CM - кандидат в мастера).
- country - Код страны шахматиста (например, `RUS`).
- sex - Пол шахматиста (`M` / `W`).
- birthdate - дата рождения шахматиста.

|  Атрибут  |       Ограничения        |
|:---------:|:------------------------:|
|    ELO    | INT NOT NULL PRIMARY KEY |
| firstname |            -             |
|  surname  |            -             |
|  country  |            -             |
|    sex    |            -             |
| birthdate |            -             |
|   title   |            -             |
|    ELO    |            -             |

### opening
- **ECO** - Индекс дебюта в международной системе ECO.
- name - Название дебюта (например, `Anderssen Opening`).
- color - Цвет, за которой играется дебют.
- pgn - Запись ходов дебюта в формате pgn.

| Атрибут |          Ограничения           |
|:-------:|:------------------------------:|
|   ECO   | PRIMARY KEY, CHAR(3), NOT NULL |
|  white  |               -                |
|  black  |               -                |
|   pgn   |     NOT NULL, VARCHAR(255)     |

### tournament
- **id** - уникальный номер события в рамках моей базы данных.
- name - Название турнира/события.
- year - Год события в формате числа.
- site - Место проведеняи события (например, Moscow RUS).

| Attribute |         Constraints         |
|:---------:|:---------------------------:|
|    id     | SERIAL NOT NULL PRIMARY KEY |
|   name    |              -              |
|   year    |              -              |
|   site    |              -              |

### Партии (game)
Атрибуты:
- **id** - уникальный номер партии в базе данных,
- white - FIDE-индекс игрока за белых,
- black - FIDE-индекс игрока за черных,
- result - Строка, отражающая результат партии ("1-0" в случае победы белых, "0-1" в случае победы черных, "1/2-1/2" в случае ничьей)
- opening - Индекс дебюта в международной системе ECO,
- dt - Дата партии,
- tournament - название туринира, в рамках которого проходила партия, либо NULL.

| Attribute  |                              Constraints                              |
|:----------:|:---------------------------------------------------------------------:|
|     id     |                          SERIAL NOT NULL, PK                          |
|   white    |     INT, FK (chess.player), ON DELETE CASCADE, ON UPDATE CASCADE      |
|   black    |     INT, FK (chess.player), ON DELETE CASCADE, ON UPDATE CASCADE      |
|   result   |                     VARCHAR(7) DEFAULT '1/2-1/2'                      |
|  opening   | VARCHAR(3), FK (chess.opening), ON DELETE SET NULL, ON UPDATE CASCADE |
|     dt     |        VARCHAR(10), FK (chess.tournament), ON DELETE SET NULL         |
| tournament |   INT, FK (chess.tournament), ON DELETE SET NULL, ON UPDATE CASCADE   |


### raiting_history
Дополнительная таблица с историей обновления рейтинга и разраядов игроков (выбран тип SCD 4).
- **FIDE** - Индекс игрока в международной системе организации ФИДЕ.
- **dt** - Дата обновления рейтинга.
- ELO - Рейтинг игрока по международной метрике ELO, используемой FIDE.
- title - Разряд в момент расчета рейтинга.

| Attribute |           Constraints           |
|:---------:|:-------------------------------:|
|   FIDE    | INT NOT NULL, FK (chess.player) |
|    dt     |          DATE NOT NULL          |
|    ELO    |          INT NOT NULL           |
|   title   |          VARCHAR(5), -          |

### amateur 
Таблица с информацией об игроках-любителях.
- **id** - Индекс игрока на chess.com,
- nickname - ник на chess.com,
- country - страна,
- last_transaction - номер последней транзакции по получению премиума (или null, если нет премиума)
- login - логин
- rating - рейтинг

| Attribute         | Constraints                          |
|-------------------|--------------------------------------|
| id                | INT NOT NULL PRIMARY KEY             |
| nickname          | TEXT                                 |
| country           | VARCHAR(3)                           |
| last_transaction  | INTEGER, DEFAULT null                |
| login             | VARCHAR(63)                          |
| rating            | INTEGER, DEFAULT 0                   |

### amateur_game
Таблица с записями игр игроков-любителей.
- **id** - индекс игры в моей системе,
- white - индекс игрока-любителя в моей системе, игравшего за белых,
- black - индекс игрока-любителя в моей системе, игравшего за черных,
- result - Строка, отражающая результат партии ("1-0" в случае победы белых, "0-1" в случае победы черных, "1/2-1/2" в случае ничьей)
- opening - ECO дебюта партии,
- dt - дата партии.

| Attribute |           Constraints           |
|:---------:|:-------------------------------:|
|     id    |   SERIAL PRIMARY KEY NOT NULL   |
|   white   | INT NOT NULL, FK(chess.amateur) |
|   black   | INT NOT NULL, FK(chess.amateur) |
|  result   |       VARCHAR(7), DEFAULT       |
|  opening  |          VARCHAR(3), -          |
|     dt    |          DATE NOT NULL          |

### premium_transaction
Информация о транзакциях покупки игроками премиум-аккаунтов. 

| Attribute        | Constraints                                |
|:-----------------|:-------------------------------------------|
| id               | SERIAL NOT NULL PRIMARY KEY                |
| player           | INT, FK (chess.amateur) ON DELETE SET NULL |
| dt               | DATE NOT NULL                              |
| premium_duration | INTERVAL NOT NULL                          |
| card_number      | VARCHAR(19) NOT NULL                       |

Структура БД представлена в файле `logical-model.jpg`. Более общая концептуальная модель в файле `conceptual-model.jpg`.
