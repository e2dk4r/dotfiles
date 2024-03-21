#!/usr/bin/env python
from sys import argv, stderr
from urllib.error import URLError, HTTPError
from urllib.request import urlopen 
import json
from os import system

def usage():
    print(f'{argv[0]} <invidious>')

def extract_paramater(url: str):
    # https://www.youtube.com/watch?v=Csb-AFD58ww
    # https://www.youtube.com/embed/Csb-AFD58ww?ad
    # https://invidious/latest_version?id=OEctB0HOpZ8&itag=22
    pathIndex = url.rfind('/')
    if pathIndex < 0:
        return url

    # watch?v=Csb-AFD58ww
    # Csb-AFD58ww?ad
    # latest_version?id=OEctB0HOpZ8&itag=22
    url = url[pathIndex + 1:]

    # Csb-AFD58ww
    # Csb-AFD58ww?ad
    # latest_version?id=OEctB0HOpZ8&itag=22
    parameterIndex = url.find(f'v=')
    if (parameterIndex > 0):
        url = url[parameterIndex + len(f'v='):]

    # Csb-AFD58ww
    # Csb-AFD58ww?ad
    # OEctB0HOpZ8&itag=22
    parameterIndex = url.find(f'id=')
    if (parameterIndex > 0):
        url = url[parameterIndex + len(f'id='):]

    # remove any other parameter
    # Csb-AFD58ww
    # Csb-AFD58ww
    # OEctB0HOpZ8
    junkIndex = url.find('&')
    if junkIndex >= 0:
        url = url[:junkIndex]
    junkIndex = url.find('?')
    if junkIndex >= 0:
        url = url[:junkIndex]
    
    return url

def main():
    if len(argv) == 1:
        usage()
        exit(1)
    videoId = argv[-1]
    videoId = extract_paramater(videoId)
    if videoId == False:
        usage()
        exit(1)

    # select domain
    domains = ('invidious.flokinet.to',
               'inv.oikei.net',
               'iv.datura.network',
               'invidious.lunar.icu',
               'invidious.nerdvpn.de',
               'invidious.einfachzocken.eu',
               'yt.oelrichsgarcia.de',
               'yt.cdaut.de',
               'iv.melmac.space',
               'yt.artemislena.eu',
               'invidious.protokolla.fi',
               'anontube.lvkaszus.pl',
               'inv.seitan-ayoub.lol',
               'invidious.privacydev.net',
               )

    for domain in domains:
        url = f'https://{domain}/api/v1/videos/{videoId}'

        # get data
        try:
            response = urlopen(url, timeout=1)

        except URLError:
            print(domain, 'url error', file=stderr)
            continue
        except HTTPError as e:
            print(domain, f'http error {e.code}', file=stderr)
            continue
        except TimeoutError:
            print(domain, 'timeout', file=stderr)
            continue
        data = json.loads(response.read().decode('utf-8'))
        response.close()

        # select title and videoId
        adaptiveFormats = data['adaptiveFormats']
        video = ''
        videoBitrate = 0
        audio = ''
        audioBitrate = 0
        for adaptiveFormat in adaptiveFormats:
            url = adaptiveFormat['url']
            bitrate = int(adaptiveFormat['bitrate'])
            type = adaptiveFormat['type']

            if type.startswith('video/'):
                if bitrate > videoBitrate:
                    video = url
                    videoBitrate = bitrate

            if type.startswith('audio/') > 0:
                if bitrate > videoBitrate:
                    audio = url
                    audioBitrate = bitrate

        if len(video) == 0:
            run(['mpv', audio])
            break
        
        system(f"mpv {' '.join(argv[1:-1])} '{video}' '--audio-file={audio}'")
        break

if __name__ == '__main__':
    main()
