@echo off
taskkill /f /im "Dropbox.exe"
cd .\scripts\
start steam://rungameid/
echo Hit enter once steam has logged in...
pause
call powershell "& '.\launch.ps1'"
call powershell "& '.\launchclient.ps1'"
call powershell "& '.\launchclient.ps1'"