chcp 65001
@echo off
set /p num1=Enter num1: 
set /p num2=Enter num2: 
set /p num3=Enter num3: 
set /a max=%num1%

if  %num2% GTR %max% (
set /a max=%num2%
)
if %num3% GTR %max% (
set /a max=%num3%
)
echo Max number: %max%

pause