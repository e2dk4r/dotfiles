@echo off

sc stop spooler

taskkill /f /t /im printfilterpipelinesvc.exe
del /q /f "%windir%\System32\Spool\Printers"

sc start spooler
