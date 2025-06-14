chcp 65001
@echo off
set /a counter = 11
goto loop

:loop
if %counter%==1 goto end
set /a counter=counter-1
echo %counter%
goto loop

:end
pause