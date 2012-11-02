@echo off 
cls 
color 0A
echo ******************************************
echo   清除该目录下所有Delphi备份文件！ 
echo ******************************************
echo. & pause
del /f /s /q *.~*
del /f /s /q *.cfg
del /f /s /q *.ddp
del /f /s /q *.dcu
del /f /s /q *.dof
echo ******************************************
echo   成功清除Delphi备份文件！ 
echo ******************************************
echo. & pause