@echo off
REM utf-8
chcp 65001

REM Prompt
REM $A   & (Ampersand)
REM $B   | (pipe)
REM $C   ( (Left parenthesis)
REM $D   Current date
REM $E   Escape code (ASCII code 27)
REM $F   ) (Right parenthesis)
REM $G   > (greater-than sign)
REM $H   Backspace (erases previous character)
REM $L   < (less-than sign)
REM $N   Current drive
REM $P   Current drive and path
REM $Q   = (equal sign)
REM $S     (space)
REM $T   Current time
REM $V   Windows version number
REM $_   Carriage return and linefeed
REM $$   $ (dollar sign)
REM ESC [ => $E[<param>
REM param description
REM   0   reset all attributes to their defaults
REM   30  set black foreground
REM   31  set red foreground
REM   32  set green foreground
REM   33  set brown foreground
REM   34  set blue foreground
REM   35  set magenta foreground
REM   36  set cyan foreground
REM   37  set white foreground
prompt $E[32m$T$E[0m$S$B$S$E[33m$P$E[0m$_$E[35m$G$E[0m$S

REM Alias
doskey ~=cd /d "%USERPROFILE%"
doskey cd=pushd $*
doskey ls=dir /b /ogn $*
doskey ll=dir /b /ogn $*
doskey cat=bat $*
doskey mv=move $*
doskey cp=xcopy $*
doskey rm=del /s /f /q $*
doskey kill=taskkill /f /t /im $1
doskey find=ag --silent -g $*
doskey pwd=echo %CD%

doskey poweroff=shutdown /s /f /t 0
doskey reboot=shutdown /r /f /t 0

doskey vi=nvim-qt $*
doskey vim=nvim-qt $*
doskey editor=nvim-qt $*
REM doskey git=hub $*

doskey f=firefox -p "e2dk4r"
doskey yt=mpv "ytdl://ytsearch5:$1"
doskey audio=mpv --no-video --loop-playlist --shuffle $*
