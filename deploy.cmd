@echo off
set "CURDIR=%~dp0"
set "CURDIR=%CURDIR:~,-1%"
set "HOME=%USERPROFILE%"

rem ssh
mklink "%HOME%\.ssh\config" "%CURDIR%\ssh\config"

rem aria2
mklink "%HOME%\.aria2\aria2.conf" "%CURDIR%\aria2\aria2.conf"

rem conemu
mklink "%HOME%\scoop\persist\conemu\ConEmu\ConEmu.xml" "%CURDIR%\conemu\conemu.xml"

rem git
mklink "%HOME%\.gitconfig" "%CURDIR%\git\gitconfig"

rem mpv
mklink "%HOME%\scoop\persist\mpv-git\portable_config\mpv.conf" "%CURDIR%\mpv\mpv.conf"
mklink "%HOME%\scoop\persist\mpv-git\portable_config\input.conf" "%CURDIR%\mpv\input.conf"

rem neovim
mklink "%HOME%\AppData\Local\nvim\init.vim" "%CURDIR%\nvim\init.vim"

rem cmd
mklink "%HOME%\profile.cmd" "%CURDIR%\cmd\profile.cmd"

rem powershell core
mklink "%HOME%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" "%CURDIR%\powershell\profile"
mklink /j "%HOME%\Documents\PowerShell\Modules" "%CURDIR%\powershell\modules"

@rem windows terminal
mklink "%HOME%\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\profiles.json" "%CURDIR%\terminal\profiles.json"
