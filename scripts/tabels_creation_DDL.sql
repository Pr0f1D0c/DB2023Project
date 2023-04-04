CREATE SCHEMA IF NOT EXISTS chess;

CREATE TABLE IF NOT EXISTS game (
    id INT PRIMARY KEY,
    white INT,
    black INT,
    result VARCHAR(7) DEFAULT '1/2-1/2',
    pgn VARCHAR(1023),
    opening VARCHAR(3),
    variation VARCHAR(255),
    dt DATE,
    tournament VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS player (
    FIDE INT NOT NULL PRIMARY KEY,
    ELO INT,
    full_name VARCHAR(255),
    last_update DATE DEFAULT now()::date,
    title VARCHAR(3),
    country VARCHAR(3),
    sex CHAR(1),
    birthdate DATE
);

CREATE TABLE IF NOT EXISTS rating_history (
    FIDE INT NOT NULL,
    dt DATE NOT NULL,
    ELO INT NOT NULL,
    delta INT,
    title VARCHAR(5),
    PRIMARY KEY (FIDE, dt)
);

CREATE TABLE IF NOT EXISTS tournament (
    name VARCHAR(255) NOT NULL PRIMARY KEY,
    year INT,
    site VARCHAR(255),
    winner INT
);

CREATE TABLE IF NOT EXISTS opening (
    ECO CHAR(3) NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    color BOOLEAN,
    pgn VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS variation (
    ECO CHAR(3) NOT NULL,
    variation VARCHAR(255) NOT NULL,
    pgn VARCHAR(255) NOT NULL,
    PRIMARY KEY (ECO, variation)
);