# firefox

Building firefox with pgo on wayland requires tinywl, that requires wayland
environment to be ready.

If you are build the latest wlroots compositor you need to rebuild tinywl and
possibly your compositor too.
```shell
# emerge -1q wlroots tinywl sway
```

```shell
# export XDG_RUNTIME_DIR=/tmp/runtime/1000
# export WAYLAND_DISPLAY=wayland-1
# emerge -1q www-client/firefox
```

