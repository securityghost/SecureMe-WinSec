```batch
@echo off
color 8A

:StartupScreen
cls
echo ####################################################
echo #        PowerShell Basic Security Script          #
echo #                 Version 2.1                      #
echo #                                                  #      
echo #                                                  #
echo #            ~Coded by SecurityGhost~              #
echo ####################################################
timeout /t 3 > NUL

net sessions > NUL
if %errorlevel% neq 0 (
    echo You need to run this script as an Administrator!
    pause
    exit
)

:Home
cls
echo  There are currently 5 sections of this script:
echo -----------------------------------------------------
echo 1 - Information Gathering
echo 2 - User Management
echo 3 - Security Configurations
echo 4 - Service Management 
echo 5 - System Patching 
echo -----------------------------------------------------
echo 6 - Reboot
echo 7 - Exit 
echo.  
set /p Choice=Type choice:

if "%Choice%"=="1" goto :Info
if "%Choice%"=="2" goto :Users
if "%Choice%"=="3" goto :Security
if "%Choice%"=="4" goto :Service
if "%Choice%"=="5" goto :Update
if "%Choice%"=="6" goto :Reboot
if "%Choice%"=="7" exit

goto :Home

:ExecutePowerShell
PowerShell -NoProfile -Command "& {Start-Process -Wait PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dp0\%1""' -Verb RunAs}"
goto :Home

:Info
cls
echo Launching Information Gathering section...
timeout /t 2
call :ExecutePowerShell reports.ps1

:Users
cls
echo Launching User Management section...
timeout /t 2
call :ExecutePowerShell manageusers.ps1

:Security
cls
echo Launching Security Policies section...
timeout /t 2
call :ExecutePowerShell security.ps1

:Service
cls
echo Launching Services section...
timeout /t 2
call :ExecutePowerShell services.ps1

:Update
cls
echo Launching Update section...
timeout /t 2
call :ExecutePowerShell updates.ps1

:Reboot
cls
color 0C 
echo Rebooting in 5...
for /l %%i in (5,-1,1) do (
    echo %%i
    timeout /t 1 > NUL
)
shutdown /r /f /t 00
```
