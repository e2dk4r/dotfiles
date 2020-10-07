@echo off
setlocal

:: == VARIABLES ==
set "YTDL_OUTPUT=D:\training\pluralsight.com\%%(playlist_title)s\%%(playlist_index)s - %%(chapter)s - %%(title)s.%%(ext)s"

:: == REQUIREMENTS ==
call :which youtube-dl
if /i "%rax%" equ "1" (
    echo error: youtube-dl not installed
    exit /b 1
)

:: == ACTION ==
youtube-dl --netrc --no-check-certificate --console-title --output "%YTDL_OUTPUT%" --add-metadata --all-subs %*
endlocal
exit /b 0

:: == FUNCTIONS ==
:usage
echo NAME
echo    lynda - download videos from lynda.com
echo SYNOPSIS
echo    lynda [ytdl_opts] url
echo DESCRIPTION
echo    lynda downloads videos from lynda.com using your username and password
echo    ytdl_opts
echo        extra youtube-dl options
echo    url
echo        course link to download
goto :eof

:which <program>
where %1 >nul 2>&1
if /i "%ERRORLEVEL%" NEQ "0" (
    set "rax=1"
)
goto :eof
