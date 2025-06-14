chcp 65001
@echo off
set /p str=Enter str: 
set /p certain=Enter certain: 
if %certain% == %str% (
echo Числа равны
) else (
echo Числа не равны
)
pause