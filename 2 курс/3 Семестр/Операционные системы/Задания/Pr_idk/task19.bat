chcp 65001
@echo off
:repeat
set /p num=Введите число от 1 до 10: 
if %num%==3 (
echo Вы угадали!
) else (
echo Вы не угадали, попробуйте еще раз
goto repeat
)

pause