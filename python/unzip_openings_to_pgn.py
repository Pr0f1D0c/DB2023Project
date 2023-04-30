import zipfile
import os

# set the directory containing the zip files
directory = "../data/sources/openings/zip/"

# loop through all the files in the directory
for filename in os.listdir(directory):
    if filename.endswith(".zip"):
        print(filename, end=' ')
        # open the zip file
        try:
            with zipfile.ZipFile(directory + filename, 'r') as zip_ref:
                # extract all files to the directory
                zip_ref.extractall(directory + '../pgn/')
                print('OK')
        except:
            print('ERROR')
