@echo off
taskkill /f /im "Dropbox.exe"
taskkill /f /im "DropboxUpdate.exe"
cd .\scripts\
start steam://rungameid/
echo Hit enter once steam has logged in...
pause
powershell "& '.\launch.ps1'"
pause