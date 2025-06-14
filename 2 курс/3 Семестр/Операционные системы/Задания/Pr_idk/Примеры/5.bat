chcp 65001
@echo off
if exist myfile.txt (
echo Файл найден!
del myfile.txt
) else (
echo Файл не найден!
)
pause