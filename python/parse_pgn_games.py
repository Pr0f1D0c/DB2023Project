import chess.pgn
import os
import csv
from nameparser import HumanName

# Чтение файла с игроками FIDE
fide_players = {}
fast_players = {}  # быстрый поиск по имени
with open('../data/csv/player.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        key = (row[1], row[2])
        fide_players[key] = row[0]


games_directory = "../data/sources/openings/pgn/"

# Подготовка csv для таблицы игр
game_csv_output_file = '../data/csv/game.csv'
game_csv_open = open(game_csv_output_file, mode="w", newline="")
game_writer = csv.writer(game_csv_open)
game_writer.writerow(["id", "white", "black", "result", "opening", "dt", "tournament"])

# Подготовка csv для турниров
tournament_csv_output_file = '../data/csv/tournament.csv'
tour_csv_open = open(tournament_csv_output_file, mode="w", newline="")
tour_writer = csv.writer(tour_csv_open)
tour_writer.writerow(["id", "name", "year", "site"])
tournament_dict = {}


def GetPlayerID(name):
    """Поиск имени по базе данных FIDE"""
    if name not in fast_players:
        nm = HumanName(name)
        nm_key = (nm.first, nm.last)
        fast_players[name] = fide_players.get(nm_key, None)
        return fide_players.get(nm_key, None)
    return fast_players[name]


def AddTournament(name, year, site):
    if name not in tournament_dict:
        tournament_dict[name] = (len(tournament_dict), year, site)
    return tournament_dict[name][0]

# Парсинг png
game_counter = 1
for filename in os.listdir(games_directory):
    if filename.endswith(".pgn"):
        print(filename)  # логирование текущего дебюта

        # open the PGN file and parse the games
        with open(games_directory + filename) as curr_game:
            local_cnt = 0
            while True:
                # if local_cnt > 100:  # по 100 игр на каждый дебют
                #     break

                try:
                    game = chess.pgn.read_headers(curr_game)
                except:
                    continue
                if game is None:
                    break

                # the game information
                if 'Date' not in game or '?' in game['Date']:
                    continue
                if game['Date'] < '1945.01.01':
                    continue

                # Распознать игрока
                white = game.get('White', None)
                black = game.get('Black', None)
                white_id = GetPlayerID(white)
                black_id = GetPlayerID(black)

                # Не добавлять партии с нераспознанными игроками
                if white_id is None or black_id is None:
                    continue

                result = game.get('Result', None)
                # pgn = str(game.mainline())
                opening = game.get('ECO', None)
                dt = game.get('Date', None)[:10]
                tournament = game.get('Event', None)
                site = game.get('Site', None)

                if tournament is not None:
                    tournament = AddTournament(tournament, dt[:4], site)

                game_writer.writerow([game_counter, white_id, black_id, result, opening, dt, tournament])

                game_counter += 1

game_csv_open.close()

for name in tournament_dict:
    ID, year, site = tournament_dict[name]
    tour_writer.writerow([ID, name, year, site])

tour_csv_open.close()

"""
пример заголовка pgn:
[Event "Vienna"]
[Site "Vienna"]
[Date "1898.??.??"]
[Round "?"]
[White "Burn, Amos"]
[Black "Chigorin, Mikhail"]
[Result "1-0"]
[WhiteElo ""]
[BlackElo ""]
[ECO "E76"]
"""
