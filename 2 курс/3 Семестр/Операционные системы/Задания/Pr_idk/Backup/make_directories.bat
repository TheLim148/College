chcp 65001
@echo off
mkdir Корень
cd Корень
mkdir Каталог1
mkdir Каталог2
cd Каталог1
mkdir Подкаталог1
mkdir Подкаталог2
cd ..
cd Каталог2
mkdir Подкаталог3
mkdir Подкаталог4
cd ..
cd ..
tree Корень
pause