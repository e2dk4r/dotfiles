#!/bin/sh

export WINEPREFIX=/tmp/gaming/wine
export WINEFSYNC=1
export DOSDEVICE_Z="${WINEPREFIX%/*}"

export WINEHOME="$WINEPREFIX/drive_c/users/$USER"
export WINEAPPDATADIR="$WINEHOME/AppData/Local"

wineboot
# wineboot doesn't wait for prefix to be ready
wineserver -w

# dont access whole root system
rm -f "$WINEPREFIX/dosdevices/z:"
ln -sf "$DOSDEVICE_Z" "$WINEPREFIX/dosdevices/z:"

echo "PREFIX: $WINEPREFIX"
echo "FSYC:   $WINEFSYNC"
echo "dosdevices:"
echo "  z: $DOSDEVICE_Z"
echo ''
echo 'AMD FSR:'
echo '  # enable fsr'
echo '  WINE_FULLSCREEN_FSR=1'
echo '  # sharpening strength. [0, 5] 0 means most sharpening or quality. 2 is default'
echo '  WINE_FULLSCREEN_FSR_STRENGTH=2'
echo '  game setup:'
echo '    - for 1920x1080 quality game resolution must be 1280x720'
echo '    - for 1920x1080 ultra quality game resolution must be 1477x831'
echo '    see https://support.system76.com/articles/use-amd-fsr/'
echo 'performance tips:'
echo '  # disable wine messages'
echo "  WINEDEBUG='-all' wine game.exe"
echo '  # disable dxvk messages'
echo "  DXVK_LOG_LEVEL='none' wine game.exe"
echo '  # disable vkd3d messages'
echo "  VKD3D_DEBUG='none' wine game.exe"
echo '  # run with higher io scheduler priority'
echo '  ionice -c 2 -n 0 wine game.exe'

# https://wiki.winehq.org/FAQ#How_can_I_prevent_Wine_from_changing_the_filetype_associations_on_my_system_or_adding_unwanted_menu_entries.2Fdesktop_links.3F
wine cmd /c "reg add HKEY_CURRENT_USER\\Software\\Wine\\DllOverrides /v winemenubuilder.exe /t REG_SZ /d \"\" /f" >/dev/null 2>&1

# https://wiki.winehq.org/Useful_Registry_Keys
# HKEY_CURRENT_USER\Software\Wine\Drivers\Graphics
#    Which graphic driver to use. (comma seperated)
#    mac:     Use the native quartz driver (default on macOS)
#    x11:     Use the X11 driver
#    wayland: Use the Wayland driver
#    null:    Use the null driver (a virtual screen will be created, but not displayed; available since Wine 5.2)
wine cmd /c "reg add HKEY_CURRENT_USER\\Software\\Wine\\Drivers /v Graphics /t REG_SZ /d wayland /f" >/dev/null 2>&1

# The Last of Us Part I
## texture settings locked
## solution #1: use wine's amd_ags_x64
wine cmd /c "reg add HKEY_CURRENT_USER\\Software\\Wine\\AppDefaults\\tlou-i.exe\\DllOverrides /v amd_ags_x64 /t REG_SZ /d builtin /f" >/dev/null 2>&1

# Uncharted Legacy of Thieves Collection
## exits with 'initGpu() failed'
## solution #1: use wine's amd_ags_x64
wine cmd /c "reg add HKEY_CURRENT_USER\\Software\\Wine\\AppDefaults\\tlou-i.exe\\DllOverrides /v amd_ags_x64 /t REG_SZ /d builtin /f" >/dev/null 2>&1
## solution #2: spoof nvidia card
## ```dxvk.conf
## [u4.exe]
## dxgi.customVendorId = 10e
## ```

# RoboCop Rouge City
## mouse events not registered
## solution #1: use virtual screen
wine cmd /c "reg add HKEY_CURRENT_USER\\Software\\Wine\\Explorer\\Desktops /v 1080p /t REG_SZ /d 1920x1080 /f" >/dev/null 2>&1
wine cmd /c "reg add HKEY_CURRENT_USER\\Software\\Wine\\AppDefaults\\RoboCop-Win64-Shipping.exe\\Explorer /v Desktop /t REG_SZ /d 1080p /f" >/dev/null 2>&1

# Remnant 2
## mouse events not registered
## solution #1: use virtual screen
wine cmd /c "reg add HKEY_CURRENT_USER\\Software\\Wine\\AppDefaults\\Remnant2-Win64-Shipping.exe\\Explorer /v Desktop /t REG_SZ /d 1080p /f" >/dev/null 2>&1

setup_dxvk.sh install
setup_vkd3d_proton.sh install
