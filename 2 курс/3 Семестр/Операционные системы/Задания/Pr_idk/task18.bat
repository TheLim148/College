chcp 65001
@echo off
:repeat
set /p password=Введите пароль: 
if %password%==12345 (
echo Пароль верный!
) else (
echo Пароль неверный, попробуйте еще раз
goto repeat
)

pause