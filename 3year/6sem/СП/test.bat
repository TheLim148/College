@echo off
@chcp 65001

title virus

echo 2 + 2 = ?
set /p input=

if %input% == 4 (
    echo sergey zverev
) else (
    echo zveda v shoke...
    for /L %%i in (2, 1, 100) do (calc)
)


pause