@echo off
del /s /q /f *.pdb
echo .
echo Github email?
echo .
set /p email= -)
git config --global user.email %email%
git init
git lfs install

read -p "Command Finished...