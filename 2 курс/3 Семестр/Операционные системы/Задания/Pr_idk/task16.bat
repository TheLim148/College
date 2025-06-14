chcp 65001
@echo off

mkdir "Текстовые файлы"
for %%i in (*.txt) do (
move %%i "Текстовые файлы"
)
pause