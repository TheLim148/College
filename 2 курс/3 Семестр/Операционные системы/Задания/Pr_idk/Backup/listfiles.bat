chcp 65001
@echo filelist.txt
for %%i in (*.txt) do (
echo Файл: %%i >> filelist.txt
)
pause