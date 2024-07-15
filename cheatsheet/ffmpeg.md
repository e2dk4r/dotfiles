# Replace Audio

```
ffmpeg -i video.mp4 -i audio.wav -map 0:v -map 1:a -c:v copy -c:a copy output.mp4
```

- If you want to re-encode video and audio then remove `-c:v copy -c:a copy`.
- The `-shortest` option will make the output the same duration as the shortest input.
