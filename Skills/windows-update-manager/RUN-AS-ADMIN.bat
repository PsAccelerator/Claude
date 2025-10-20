@echo off
REM Windows Update Manager - Quick Launcher
REM Right-click this file and select "Run as Administrator"

echo ========================================
echo   Windows Update Manager
echo ========================================
echo.

REM Check if running as admin
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Running with Administrator privileges
    echo.
) else (
    echo [ERROR] This script requires Administrator privileges!
    echo.
    echo Please:
    echo 1. Right-click this file
    echo 2. Select "Run as administrator"
    echo.
    pause
    exit /b 1
)

cd /d "%~dp0"

:menu
echo.
echo What would you like to do?
echo.
echo 1. Check for updates (safe, no changes)
echo 2. Install updates (manual reboot)
echo 3. Install updates with AUTO-REBOOT
echo 4. Generate update report
echo 5. Test mode (dry run)
echo 6. Exit
echo.
set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto check
if "%choice%"=="2" goto install
if "%choice%"=="3" goto install_auto
if "%choice%"=="4" goto report
if "%choice%"=="5" goto dryrun
if "%choice%"=="6" goto end

echo Invalid choice. Please try again.
goto menu

:check
echo.
echo Checking for updates...
powershell -ExecutionPolicy Bypass -File ".\Windows-Update-Manager.ps1" -Action Check
goto continue

:install
echo.
echo Installing updates (you will need to reboot manually)...
powershell -ExecutionPolicy Bypass -File ".\Windows-Update-Manager.ps1" -Action Install
goto continue

:install_auto
echo.
echo WARNING: This will automatically reboot your PC after installation!
set /p confirm="Are you sure? (Y/N): "
if /i "%confirm%"=="Y" (
    echo.
    echo Installing updates with auto-reboot...
    powershell -ExecutionPolicy Bypass -File ".\Windows-Update-Manager.ps1" -Action Install -AutoReboot
) else (
    echo Cancelled.
)
goto continue

:report
echo.
echo Generating update report...
powershell -ExecutionPolicy Bypass -File ".\Windows-Update-Manager.ps1" -Action Report
goto continue

:dryrun
echo.
echo Running in TEST MODE (no actual changes)...
powershell -ExecutionPolicy Bypass -File ".\Windows-Update-Manager.ps1" -Action Install -DryRun
goto continue

:continue
echo.
echo ========================================
echo.
set /p again="Run another action? (Y/N): "
if /i "%again%"=="Y" goto menu

:end
echo.
echo Logs saved to: %TEMP%\WindowsUpdateManager\
echo.
echo Thank you for using Windows Update Manager!
pause
