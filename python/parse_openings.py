import chess.pgn
import csv

opening_csv_file = '../data/csv/opening.csv'
csv_open = open(opening_csv_file, mode="w", newline="")
writer = csv.writer(csv_open)
writer.writerow(["eco", "white_name", "black_name", "pgn"])

IDs = set()

eco_file = '../data/sources/eco.pgn'
with open(eco_file, "r", encoding="ISO-8859-1") as curr_game:
    while True:
        try:
            game = chess.pgn.read_game(curr_game)
        except:
            continue

        if game is None:
            break

        eco = game.headers['Site']
        white = game.headers.get('White', None)
        black = game.headers.get('Black', None)

        if eco in IDs:
            continue
        else:
            IDs.add(eco)

        try:
            pgn = str(game.mainline())
        except:
            continue

        writer.writerow([eco, white, black, pgn])

csv_open.close()
