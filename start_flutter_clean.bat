@echo off
echo Starting Flutter on Port 3000 - Clean Start
echo ===========================================

REM Kill any processes using port 3000
echo Checking for processes using port 3000...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3000') do (
    echo Killing process %%a
    taskkill /f /pid %%a >nul 2>&1
)

REM Kill any existing Flutter/Dart processes
echo Cleaning up Flutter processes...
taskkill /f /im dart.exe >nul 2>&1
taskkill /f /im flutter.exe >nul 2>&1

REM Wait for processes to close
echo Waiting for cleanup...
timeout /t 3 /nobreak >nul

REM Verify port 3000 is free
netstat -ano | findstr :3000 >nul
if %ERRORLEVEL% EQU 0 (
    echo ERROR: Port 3000 is still in use!
    echo Please manually close the application using port 3000
    pause
    exit /b 1
)

echo Port 3000 is free. Starting Flutter...
echo.

REM Start Flutter on port 3000
flutter run -d edge --web-port=3000 --web-hostname=localhost

echo.
echo Flutter should now be running on http://localhost:3000
pause
