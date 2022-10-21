@echo off
taskkill /f /im "Dropbox.exe"
cd .\scripts\
start steam://rungameid/
echo Hit enter once steam has logged in...
pause
powershell "& '.\launch.ps1'"
pause