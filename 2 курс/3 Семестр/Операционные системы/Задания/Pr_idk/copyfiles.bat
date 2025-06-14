chcp 65001
mkdir TextFiles
for %%i in (*.txt) do (
copy %%i TextFiles\%%i
)
pause