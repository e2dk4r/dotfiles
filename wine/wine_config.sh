export WINEPREFIX=/tmp/gaming/wine
export WINEFSYNC=1
export DOSDEVICE_Z="${WINEPREFIX%/*}"

export WINEHOME="$WINEPREFIX/drive_c/users/$USER"
export WINEAPPDATADIR="$WINEHOME/AppData/Local"
