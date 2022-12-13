@echo off
taskkill /f /im "Dropbox.exe"
cd .\scripts\
start "" powershell "& '.\launchserver.ps1'"
start "" powershell "& '.\launchclient.ps1'"