@echo off
taskkill /f /im "Dropbox.exe"
cd .\scripts\
powershell "& '.\launchserver.ps1'"
pause