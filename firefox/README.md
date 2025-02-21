# Profile

Running firefox from [my script](../bin/firefox) unfortunately requires you to set
`profiles.ini` file.

```
$ cat $HOME/.mozilla/firefox/profiles.ini
[Profile1]
Name=temporary
IsRelative=0
Path=/tmp/runtime/1000/firefox
```

[What is profiles.ini](https://kb.mozillazine.org/Profiles.ini_file)

