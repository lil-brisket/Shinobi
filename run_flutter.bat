@echo off
echo Starting Flutter on Port 3000
echo =============================

REM Kill any existing Flutter/Dart processes to free up port 3000
echo Cleaning up existing processes...
taskkill /f /im dart.exe >nul 2>&1
taskkill /f /im flutter.exe >nul 2>&1

REM Wait for cleanup
timeout /t 2 /nobreak >nul

REM Start Flutter on port 3000
echo Starting Flutter on localhost:3000...
flutter run -d edge --web-port=3000 --web-hostname=localhost

echo.
echo Flutter is running at: http://localhost:3000
pause
