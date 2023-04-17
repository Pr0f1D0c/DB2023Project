CREATE SCHEMA IF NOT EXISTS chess;

CREATE TABLE IF NOT EXISTS chess.game (
    id INT PRIMARY KEY,
    white INT,
    black INT,
    result VARCHAR(7) DEFAULT '1/2-1/2',
    pgn VARCHAR(1023),
    opening VARCHAR(3),
    variation VARCHAR(255),
    dt DATE,
    tournament INTEGER,

    CONSTRAINT fk_game_white FOREIGN KEY (white)
        REFERENCES chess.player(FIDE) ON DELETE CASCADE,
    CONSTRAINT fk_game_black FOREIGN KEY (black)
        REFERENCES chess.player(FIDE) ON DELETE CASCADE,
    CONSTRAINT fk_game_tournament FOREIGN KEY (tournament)
        REFERENCES chess.tournament(id) ON DELETE SET NULL,
    CONSTRAINT fk_game_opening FOREIGN KEY (opening)
        REFERENCES chess.opening(ECO) ON DELETE SET NULL,
    CONSTRAINT fk_game_variation FOREIGN KEY (opening, variation)
        REFERENCES chess.variation(ECO, variation) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS chess.player (
    FIDE INT NOT NULL PRIMARY KEY,
    ELO INT,
    full_name VARCHAR(255),
    last_update DATE DEFAULT now()::date,
    title VARCHAR(3),
    country VARCHAR(3),
    sex CHAR(1),
    birthdate DATE
);

CREATE TABLE IF NOT EXISTS chess.rating_history (
    FIDE INT NOT NULL,
    dt DATE NOT NULL,
    ELO INT NOT NULL,
    delta INT,
    title VARCHAR(5),
    PRIMARY KEY (FIDE, dt),

    CONSTRAINT fk_rating_player FOREIGN KEY (FIDE)
        REFERENCES chess.player(FIDE) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS chess.tournament (
    id INTEGER NOT NULL PRIMARY KEY,
    name VARCHAR(255),
    year INT,
    site VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS chess.opening (
    ECO CHAR(3) NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    color BOOLEAN,
    pgn VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS chess.variation (
    ECO CHAR(3) NOT NULL,
    variation VARCHAR(255) NOT NULL,
    pgn VARCHAR(255) NOT NULL,
    PRIMARY KEY (ECO, variation),

    CONSTRAINT fk_variation_opening FOREIGN KEY (ECO)
        REFERENCES chess.opening(ECO) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS chess.amateur_game (
    id INT PRIMARY KEY,
    white INT NOT NULL,
    black INT NOT NULL,
    result VARCHAR(7) DEFAULT '1/2-1/2',
    pgn VARCHAR(1023),
    opening VARCHAR(3),
    variation VARCHAR(255),
    dt DATE,

    CONSTRAINT fk_amateur_game_white FOREIGN KEY (white)
        REFERENCES chess.amateur(id) ON DELETE CASCADE,
    CONSTRAINT fk_amateur_game_black FOREIGN KEY (black)
        REFERENCES chess.amateur(id) ON DELETE CASCADE,
    CONSTRAINT fk_amateur_game_opening FOREIGN KEY (opening)
        REFERENCES chess.opening(ECO) ON DELETE SET NULL,
    CONSTRAINT fk_amateur_game_variation FOREIGN KEY (opening, variation)
        REFERENCES chess.variation(ECO, variation) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS chess.amateur (
    id INT NOT NULL PRIMARY KEY,
    nickname TEXT,
    country VARCHAR(3),
    last_transaction INTEGER NOT NULL,
    login varchar(63)
);

CREATE TABLE IF NOT EXISTS chess.premium_transaction (
    id INT NOT NULL PRIMARY KEY,
    player INT,
    dt DATE NOT NULL,
    premium_duration INTERVAL NOT NULL,
    card_number VARCHAR(16) NOT NULL,

    CONSTRAINT fk_premium_amateur FOREIGN KEY (player)
        REFERENCES chess.amateur(id) ON DELETE SET NULL
)