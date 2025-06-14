chcp 65001
@echo off

mkdir TextFiles
for %%i in (*.txt) do (
copy %%i TextFiles\%%i
)
pause