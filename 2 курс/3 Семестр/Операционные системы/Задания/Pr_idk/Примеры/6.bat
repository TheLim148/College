chcp 65001
set /A COUNTER = 1
goto loop

:loop
if %COUNTER% == 9 goto end
set /A COUNTER = COUNTER + 1
notepad.exe
goto loop
:end
pause