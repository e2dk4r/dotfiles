from urllib.request import urlopen 
import json
from sys import argv 

def usage():
    print(f'{argv[0]} <playlistId>')

def extract_paramater(url: str, parameter: str):
    # https://www.youtube.com/playlist?list=PLjEaoINr3zgEPv5y--4MKpciLaoQYZB1Z
    pathIndex = url.rfind('/')
    if pathIndex < 0:
        return url

    # playlist?list=PLjEaoINr3zgEPv5y--4MKpciLaoQYZB1Z
    url = url[pathIndex + 1:]

    parameterIndex = url.find(f'{parameter}=')
    if parameterIndex < 0:
        return False

    # PLjEaoINr3zgEPv5y--4MKpciLaoQYZB1Z
    url = url[parameterIndex + len(f'{parameter}='):]

    # remove any other parameter
    andIndex = url.find('&')
    if andIndex >= 0:
        url = url[:andIndex]
    
    return url

def main():
    if len(argv) != 2:
        usage()
        exit(1)
    playlistId = argv[-1]
    playlistId = extract_paramater(playlistId, 'list')
    if playlistId == False:
        usage()
        exit(1)

    # select domain
    domain = 'inv.oikei.net'
    url = f'https://{domain}/api/v1/playlists/{playlistId}'

    # get data
    response = urlopen(url)
    if response.status != 200:
        exit(1)

    data = json.loads(response.read().decode('utf-8'))

    # select title and videoId
    videos = data['videos']
    for video in videos:
        title = video['title']
        videoId = video['videoId']
        # join every 2 line together
        print(title, videoId)

if __name__ == '__main__':
    main()
