# hls playlist file extensions not allowed

```sh
$ mpv https://example.com/file.m3u8
[ffmpeg/demuxer] hls: URL https://example.com/file.m3u8 is not in allowed_extensions
```

Fix by below command:

```
$ mpv --demuxer-lavf-o-append=extension_picky=0 https://example.com/file.m3u8
```

References:
- man ffmpeg-formats.1

  `DEMUXERS > hls > allowed_extensions`
  `DEMUXERS > hls > extension_picky`
