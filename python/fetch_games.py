import psycopg2
import requests
import re
import urllib.request
from time import sleep

url = 'https://pgnmentor.com/files.html#openings'
html_text = requests.get(url).text

pattern = r"openings/[^\"]*\.zip"
a = re.findall(pattern, html_text)
print(pattern, len(a))


start_file = 0
for index, name in enumerate(a[(start_file * 2)::2], start_file):
    file_url = f'https://pgnmentor.com/{name}'
    file_name = name[9:]
    print(file_url, file_name, index)
    try:
        urllib.request.urlretrieve(file_url, f'../data/sources/openings/zip/{file_name}')
    except:
        pass
    sleep(0.5)
