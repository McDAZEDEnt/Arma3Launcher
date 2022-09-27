echo off
cd .\scripts\
start steam://rungameid/
echo Hit enter once steam has logged in...
pause
powershell "& '.\launchfp.ps1'"
pause