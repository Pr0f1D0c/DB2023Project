from nameparser import HumanName
import csv

people = {}
csv_file = '../data/csv/player.csv'
f = open(csv_file, mode="w", newline="")
writer = csv.writer(f)
writer.writerow(["id", "firstname", "surname", "fed", "sex", "b_day", "title", "ELO"])

with open('../data/sources/FIDE.txt', 'r') as file:
    _ = file.readline()
    for line in file:
        sex = line[80]
        B_dat = int(line[152:152+4])
        name = line[15:76].rstrip()
        fed = line[76:76+3]
        ID = int(line[:15].rstrip())
        nm = HumanName(name)
        key = (nm.first, nm.last)
        people[key] = ID
        elo = int(line[126:126+4]) if line[126:126+4] != ' ' * 4 else 0
        title = line[84:84 + 2]
        writer.writerow([ID, nm.first, nm.last, fed, sex, B_dat, title, elo])

f.close()
