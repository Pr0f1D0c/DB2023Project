import subprocess

need_fetch = False
if need_fetch:
    subprocess.run(["python3", "fetch_games.py"], check=True)
    print('=====>>>>> Fetch complete')
    subprocess.run(["python3", "unzip_openings_to_pgn.py"], check=True)
    print('=====>>>>> Unzip complete')

subprocess.run(["python3", "./FIDE_parser.py"], check=True)
print('=====>>>>> FIDE.txt parse complete')
subprocess.run(["python3", "./parse_openings.py"], check=True)
print('=====>>>>> ECO.pgn parse complete')
subprocess.run(["python3", "./parse_pgn_games.py"], check=True)
print('=====>>>>> games parse complete')
print('DONE')
