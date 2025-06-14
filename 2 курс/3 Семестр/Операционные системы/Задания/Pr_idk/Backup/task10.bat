chcp 65001
@echo off
set /A COUNTER = 1

for %%i in (*.*) do (
set /A COUNTER = COUNTER + 1
)
echo %COUNTER%
pause