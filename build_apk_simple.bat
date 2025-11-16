@echo off
cd /d "%~dp0app"

echo ========================================
echo Building APK - Step by Step
echo ========================================
echo.

echo [1/4] Getting dependencies...
call flutter pub get
if errorlevel 1 (
    echo ERROR in step 1
    pause
    exit /b 1
)
echo.

echo [2/4] Generating code...
call flutter pub run build_runner build --delete-conflicting-outputs
echo.

echo [3/4] Building APK (this takes 2-5 minutes)...
call flutter build apk --debug
if errorlevel 1 (
    echo ERROR in step 3
    pause
    exit /b 1
)
echo.

echo [4/4] Checking APK...
if exist "build\app\outputs\flutter-apk\app-debug.apk" (
    echo.
    echo ========================================
    echo SUCCESS! APK Generated!
    echo ========================================
    echo.
    echo Location: %CD%\build\app\outputs\flutter-apk\app-debug.apk
    echo.
) else (
    echo ERROR: APK not found!
)

pause

