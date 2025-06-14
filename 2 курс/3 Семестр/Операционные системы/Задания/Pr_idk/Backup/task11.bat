chcp 65001
@echo off

if exist example.txt (
echo Файл суещствует!
) else (
echo Файл не сущестует!
)
pause