#!/usr/bin/env python
from sys import argv, stderr
from urllib.error import URLError, HTTPError
from urllib.request import urlopen 
import json
import subprocess

domains = (
  'inv.ngn.tf', # TR
  'yt.drgnz.club', # CZ
  'iv.nboeck.de', # DE
  'iv.melmac.space', # DE
  'yt.artemislena.eu', # DE
  'yt.cdaut.de', # DE
  'iv.datura.network', # FI
  'invidious.nerdvpn.de', # UA
  'inv.nadeko.net', # CL
  'invidious.privacydev.net', # FR
  'invidious.flokinet.to', # RO
  'invidious.protokolla.fi', # BG
  'invidious.lunar.icu', # DE, CF
)

# see: https://github.com/yt-dlp/yt-dlp/raw/master/yt_dlp/extractor/youtube.py
formats = {
    '5': {'ext': 'flv', 'width': 400, 'height': 240, 'acodec': 'mp3', 'abr': 64, 'vcodec': 'h263'},
    '6': {'ext': 'flv', 'width': 450, 'height': 270, 'acodec': 'mp3', 'abr': 64, 'vcodec': 'h263'},
    '13': {'ext': '3gp', 'acodec': 'aac', 'vcodec': 'mp4v'},
    '17': {'ext': '3gp', 'width': 176, 'height': 144, 'acodec': 'aac', 'abr': 24, 'vcodec': 'mp4v'},
    '18': {'ext': 'mp4', 'width': 640, 'height': 360, 'acodec': 'aac', 'abr': 96, 'vcodec': 'h264'},
    '22': {'ext': 'mp4', 'width': 1280, 'height': 720, 'acodec': 'aac', 'abr': 192, 'vcodec': 'h264'},
    '34': {'ext': 'flv', 'width': 640, 'height': 360, 'acodec': 'aac', 'abr': 128, 'vcodec': 'h264'},
    '35': {'ext': 'flv', 'width': 854, 'height': 480, 'acodec': 'aac', 'abr': 128, 'vcodec': 'h264'},
    # itag 36 videos are either 320x180 (BaW_jenozKc) or 320x240 (__2ABJjxzNo), abr varies as well
    '36': {'ext': '3gp', 'width': 320, 'acodec': 'aac', 'vcodec': 'mp4v'},
    '37': {'ext': 'mp4', 'width': 1920, 'height': 1080, 'acodec': 'aac', 'abr': 192, 'vcodec': 'h264'},
    '38': {'ext': 'mp4', 'width': 4096, 'height': 3072, 'acodec': 'aac', 'abr': 192, 'vcodec': 'h264'},
    '43': {'ext': 'webm', 'width': 640, 'height': 360, 'acodec': 'vorbis', 'abr': 128, 'vcodec': 'vp8'},
    '44': {'ext': 'webm', 'width': 854, 'height': 480, 'acodec': 'vorbis', 'abr': 128, 'vcodec': 'vp8'},
    '45': {'ext': 'webm', 'width': 1280, 'height': 720, 'acodec': 'vorbis', 'abr': 192, 'vcodec': 'vp8'},
    '46': {'ext': 'webm', 'width': 1920, 'height': 1080, 'acodec': 'vorbis', 'abr': 192, 'vcodec': 'vp8'},
    '59': {'ext': 'mp4', 'width': 854, 'height': 480, 'acodec': 'aac', 'abr': 128, 'vcodec': 'h264'},
    '78': {'ext': 'mp4', 'width': 854, 'height': 480, 'acodec': 'aac', 'abr': 128, 'vcodec': 'h264'},

    # 3D videos
    '82': {'ext': 'mp4', 'height': 360, 'format_note': '3D', 'acodec': 'aac', 'abr': 128, 'vcodec': 'h264', 'preference': -20},
    '83': {'ext': 'mp4', 'height': 480, 'format_note': '3D', 'acodec': 'aac', 'abr': 128, 'vcodec': 'h264', 'preference': -20},
    '84': {'ext': 'mp4', 'height': 720, 'format_note': '3D', 'acodec': 'aac', 'abr': 192, 'vcodec': 'h264', 'preference': -20},
    '85': {'ext': 'mp4', 'height': 1080, 'format_note': '3D', 'acodec': 'aac', 'abr': 192, 'vcodec': 'h264', 'preference': -20},
    '100': {'ext': 'webm', 'height': 360, 'format_note': '3D', 'acodec': 'vorbis', 'abr': 128, 'vcodec': 'vp8', 'preference': -20},
    '101': {'ext': 'webm', 'height': 480, 'format_note': '3D', 'acodec': 'vorbis', 'abr': 192, 'vcodec': 'vp8', 'preference': -20},
    '102': {'ext': 'webm', 'height': 720, 'format_note': '3D', 'acodec': 'vorbis', 'abr': 192, 'vcodec': 'vp8', 'preference': -20},

    # Apple HTTP Live Streaming
    '91': {'ext': 'mp4', 'height': 144, 'format_note': 'HLS', 'acodec': 'aac', 'abr': 48, 'vcodec': 'h264', 'preference': -10},
    '92': {'ext': 'mp4', 'height': 240, 'format_note': 'HLS', 'acodec': 'aac', 'abr': 48, 'vcodec': 'h264', 'preference': -10},
    '93': {'ext': 'mp4', 'height': 360, 'format_note': 'HLS', 'acodec': 'aac', 'abr': 128, 'vcodec': 'h264', 'preference': -10},
    '94': {'ext': 'mp4', 'height': 480, 'format_note': 'HLS', 'acodec': 'aac', 'abr': 128, 'vcodec': 'h264', 'preference': -10},
    '95': {'ext': 'mp4', 'height': 720, 'format_note': 'HLS', 'acodec': 'aac', 'abr': 256, 'vcodec': 'h264', 'preference': -10},
    '96': {'ext': 'mp4', 'height': 1080, 'format_note': 'HLS', 'acodec': 'aac', 'abr': 256, 'vcodec': 'h264', 'preference': -10},
    '132': {'ext': 'mp4', 'height': 240, 'format_note': 'HLS', 'acodec': 'aac', 'abr': 48, 'vcodec': 'h264', 'preference': -10},
    '151': {'ext': 'mp4', 'height': 72, 'format_note': 'HLS', 'acodec': 'aac', 'abr': 24, 'vcodec': 'h264', 'preference': -10},

    # DASH mp4 video
    '133': {'ext': 'mp4', 'height': 240, 'format_note': 'DASH video', 'vcodec': 'h264'},
    '134': {'ext': 'mp4', 'height': 360, 'format_note': 'DASH video', 'vcodec': 'h264'},
    '135': {'ext': 'mp4', 'height': 480, 'format_note': 'DASH video', 'vcodec': 'h264'},
    '136': {'ext': 'mp4', 'height': 720, 'format_note': 'DASH video', 'vcodec': 'h264'},
    '137': {'ext': 'mp4', 'height': 1080, 'format_note': 'DASH video', 'vcodec': 'h264'},
    '138': {'ext': 'mp4', 'format_note': 'DASH video', 'vcodec': 'h264'},  # Height can vary (https://github.com/ytdl-org/youtube-dl/issues/4559)
    '160': {'ext': 'mp4', 'height': 144, 'format_note': 'DASH video', 'vcodec': 'h264'},
    '212': {'ext': 'mp4', 'height': 480, 'format_note': 'DASH video', 'vcodec': 'h264'},
    '264': {'ext': 'mp4', 'height': 1440, 'format_note': 'DASH video', 'vcodec': 'h264'},
    '298': {'ext': 'mp4', 'height': 720, 'format_note': 'DASH video', 'vcodec': 'h264', 'fps': 60},
    '299': {'ext': 'mp4', 'height': 1080, 'format_note': 'DASH video', 'vcodec': 'h264', 'fps': 60},
    '266': {'ext': 'mp4', 'height': 2160, 'format_note': 'DASH video', 'vcodec': 'h264'},

    # Dash mp4 audio
    '139': {'ext': 'm4a', 'format_note': 'DASH audio', 'acodec': 'aac', 'abr': 48, 'container': 'm4a_dash'},
    '140': {'ext': 'm4a', 'format_note': 'DASH audio', 'acodec': 'aac', 'abr': 128, 'container': 'm4a_dash'},
    '141': {'ext': 'm4a', 'format_note': 'DASH audio', 'acodec': 'aac', 'abr': 256, 'container': 'm4a_dash'},
    '256': {'ext': 'm4a', 'format_note': 'DASH audio', 'acodec': 'aac', 'container': 'm4a_dash'},
    '258': {'ext': 'm4a', 'format_note': 'DASH audio', 'acodec': 'aac', 'container': 'm4a_dash'},
    '325': {'ext': 'm4a', 'format_note': 'DASH audio', 'acodec': 'dtse', 'container': 'm4a_dash'},
    '328': {'ext': 'm4a', 'format_note': 'DASH audio', 'acodec': 'ec-3', 'container': 'm4a_dash'},

    # Dash webm
    '167': {'ext': 'webm', 'height': 360, 'width': 640, 'format_note': 'DASH video', 'container': 'webm', 'vcodec': 'vp8'},
    '168': {'ext': 'webm', 'height': 480, 'width': 854, 'format_note': 'DASH video', 'container': 'webm', 'vcodec': 'vp8'},
    '169': {'ext': 'webm', 'height': 720, 'width': 1280, 'format_note': 'DASH video', 'container': 'webm', 'vcodec': 'vp8'},
    '170': {'ext': 'webm', 'height': 1080, 'width': 1920, 'format_note': 'DASH video', 'container': 'webm', 'vcodec': 'vp8'},
    '218': {'ext': 'webm', 'height': 480, 'width': 854, 'format_note': 'DASH video', 'container': 'webm', 'vcodec': 'vp8'},
    '219': {'ext': 'webm', 'height': 480, 'width': 854, 'format_note': 'DASH video', 'container': 'webm', 'vcodec': 'vp8'},
    '278': {'ext': 'webm', 'height': 144, 'format_note': 'DASH video', 'container': 'webm', 'vcodec': 'vp9'},
    '242': {'ext': 'webm', 'height': 240, 'format_note': 'DASH video', 'vcodec': 'vp9'},
    '243': {'ext': 'webm', 'height': 360, 'format_note': 'DASH video', 'vcodec': 'vp9'},
    '244': {'ext': 'webm', 'height': 480, 'format_note': 'DASH video', 'vcodec': 'vp9'},
    '245': {'ext': 'webm', 'height': 480, 'format_note': 'DASH video', 'vcodec': 'vp9'},
    '246': {'ext': 'webm', 'height': 480, 'format_note': 'DASH video', 'vcodec': 'vp9'},
    '247': {'ext': 'webm', 'height': 720, 'format_note': 'DASH video', 'vcodec': 'vp9'},
    '248': {'ext': 'webm', 'height': 1080, 'format_note': 'DASH video', 'vcodec': 'vp9'},
    '271': {'ext': 'webm', 'height': 1440, 'format_note': 'DASH video', 'vcodec': 'vp9'},
    # itag 272 videos are either 3840x2160 (e.g. RtoitU2A-3E) or 7680x4320 (sLprVF6d7Ug)
    '272': {'ext': 'webm', 'height': 2160, 'format_note': 'DASH video', 'vcodec': 'vp9'},
    '302': {'ext': 'webm', 'height': 720, 'format_note': 'DASH video', 'vcodec': 'vp9', 'fps': 60},
    '303': {'ext': 'webm', 'height': 1080, 'format_note': 'DASH video', 'vcodec': 'vp9', 'fps': 60},
    '308': {'ext': 'webm', 'height': 1440, 'format_note': 'DASH video', 'vcodec': 'vp9', 'fps': 60},
    '313': {'ext': 'webm', 'height': 2160, 'format_note': 'DASH video', 'vcodec': 'vp9'},
    '315': {'ext': 'webm', 'height': 2160, 'format_note': 'DASH video', 'vcodec': 'vp9', 'fps': 60},

    # Dash webm audio
    '171': {'ext': 'webm', 'acodec': 'vorbis', 'format_note': 'DASH audio', 'abr': 128},
    '172': {'ext': 'webm', 'acodec': 'vorbis', 'format_note': 'DASH audio', 'abr': 256},

    # Dash webm audio with opus inside
    '249': {'ext': 'webm', 'format_note': 'DASH audio', 'acodec': 'opus', 'abr': 50},
    '250': {'ext': 'webm', 'format_note': 'DASH audio', 'acodec': 'opus', 'abr': 70},
    '251': {'ext': 'webm', 'format_note': 'DASH audio', 'acodec': 'opus', 'abr': 160},

    # RTMP (unnamed)
    '_rtmp': {'protocol': 'rtmp'},

    # av01 video only formats sometimes served with "unknown" codecs
    '394': {'ext': 'mp4', 'height': 144, 'format_note': 'DASH video', 'vcodec': 'av01.0.00M.08'},
    '395': {'ext': 'mp4', 'height': 240, 'format_note': 'DASH video', 'vcodec': 'av01.0.00M.08'},
    '396': {'ext': 'mp4', 'height': 360, 'format_note': 'DASH video', 'vcodec': 'av01.0.01M.08'},
    '397': {'ext': 'mp4', 'height': 480, 'format_note': 'DASH video', 'vcodec': 'av01.0.04M.08'},
    '398': {'ext': 'mp4', 'height': 720, 'format_note': 'DASH video', 'vcodec': 'av01.0.05M.08'},
    '399': {'ext': 'mp4', 'height': 1080, 'format_note': 'DASH video', 'vcodec': 'av01.0.08M.08'},
    '400': {'ext': 'mp4', 'height': 1440, 'format_note': 'DASH video', 'vcodec': 'av01.0.12M.08'},
    '401': {'ext': 'mp4', 'height': 2160, 'format_note': 'DASH video', 'vcodec': 'av01.0.12M.08'},

'229': {'ext': 'mp4', 'height': 240,  'format_note': 'DASH video', 'vcodec': 'avc1.4D4015'},
'230': {'ext': 'mp4', 'height': 360,  'format_note': 'DASH video', 'vcodec': 'avc1.4D401E'},
'231': {'ext': 'mp4', 'height': 480,  'format_note': 'DASH video', 'vcodec': 'avc1.4D401F'},
'232': {'ext': 'mp4', 'height': 720,  'format_note': 'DASH video', 'vcodec': 'avc1.4D401F'},
'269': {'ext': 'mp4', 'height': 144,  'format_note': 'DASH video', 'vcodec': 'avc1.4D400C'},
'270': {'ext': 'mp4', 'height': 1080, 'format_note': 'DASH video', 'vcodec': 'avc1.640028'},

'571': {'ext': 'mp4', 'height': 4320, 'format_note': 'DASH video', 'vcodec': 'av01.0.16M.08'},

'602': {'ext': 'mp4', 'height': 144,  'format_note': 'DASH video', 'vcodec': 'vp09.00.10.08'},
'603': {'ext': 'mp4', 'height': 144,  'format_note': 'DASH video', 'vcodec': 'vp09.00.11.08'},
'604': {'ext': 'mp4', 'height': 240,  'format_note': 'DASH video', 'vcodec': 'vp09.00.20.08'},
'605': {'ext': 'mp4', 'height': 360,  'format_note': 'DASH video', 'vcodec': 'vp09.00.21.08'},
'606': {'ext': 'mp4', 'height': 480,  'format_note': 'DASH video', 'vcodec': 'vp09.00.30.08'},
'609': {'ext': 'mp4', 'height': 720,  'format_note': 'DASH video', 'vcodec': 'vp09.00.31.08'},
'614': {'ext': 'mp4', 'height': 1080, 'format_note': 'DASH video', 'vcodec': 'vp09.00.40.08'},
'620': {'ext': 'mp4', 'height': 1440, 'format_note': 'DASH video', 'vcodec': 'vp09.00.50.08'},
'625': {'ext': 'mp4', 'height': 2160, 'format_note': 'DASH video', 'vcodec': 'vp09.00.50.08'},


'330': {'ext': 'webm', 'height': 128, 'format_note': 'DASH video', 'vcodec': 'vp9'},
'331': {'ext': 'webm', 'height': 214, 'format_note': 'DASH video', 'vcodec': 'vp9'},
'332': {'ext': 'webm', 'height': 320, 'format_note': 'DASH video', 'vcodec': 'vp9'},
'333': {'ext': 'webm', 'height': 428, 'format_note': 'DASH video', 'vcodec': 'vp9'},
'334': {'ext': 'webm', 'height': 640, 'format_note': 'DASH video', 'vcodec': 'vp9'},
'335': {'ext': 'webm', 'height': 960, 'format_note': 'DASH video', 'vcodec': 'vp9'},
'336': {'ext': 'webm', 'height': 1280, 'format_note': 'DASH video', 'vcodec': 'vp9'},
'337': {'ext': 'webm', 'height': 1920, 'format_note': 'DASH video', 'vcodec': 'vp9'},

'779': {'ext': 'webm', 'height': 608, 'format_note': 'DASH video', 'vcodec': 'vp9'},
'780': {'ext': 'webm', 'height': 608, 'format_note': 'DASH video', 'vcodec': 'vp9'},
}
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

    print('videoId:', videoId)

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

        try:
            data = json.loads(response.read().decode('utf-8'))
        except json.decoder.JSONDecodeError:
            print(domain, f'json decoding error', file=stderr)
            response.close()
            continue
        response.close()

        #with open('/tmp/json', 'w', encoding='utf-8') as f:
        #  f.write(json.dumps(data))

        print('domain:', domain)

        # select title and videoId
        title = data['title']
        adaptiveFormats = data['adaptiveFormats']
        video = ''
        videoBitrate = 0
        audio = ''
        audioBitrate = 0
        for adaptiveFormat in adaptiveFormats:
            if 'bitrate' not in adaptiveFormat:
                continue
            url = adaptiveFormat['url']
            bitrate = int(adaptiveFormat['bitrate'])
            type = adaptiveFormat['type']
            itag = adaptiveFormat['itag']
            format = formats.get(itag)

            if type.startswith('video/'):
                if int(format.get('height')) > 1080:
                    continue
                if format.get('vcodec') == 'vp9':
                    continue
                if bitrate > videoBitrate:
                    video = url
                    videoBitrate = bitrate

            if type.startswith('audio/') > 0:
                if bitrate > videoBitrate:
                    audio = url
                    audioBitrate = bitrate

        command = [ 'mpv' ]
        command += [ f"--force-media-title={title}" ]
        if len(argv) > 2:
          command += [ ' '.join(argv[1:-1]) ]
        command += [ f"--script-opts=sponsorblock-videoId={videoId}" ]

        if video == '':
            command += [ audio ]
        else:
            command += [ video, f"--audio-file={audio}" ]

        subprocess.run(command)
        exit(0)

if __name__ == '__main__':
    main()
