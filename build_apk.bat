@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Emergency Response App - Building APK...
echo ========================================
echo.

REM Change to app directory
cd /d "%~dp0app"
if errorlevel 1 (
    echo ERROR: Cannot find app directory!
    echo Make sure you're running this from the project root.
    echo.
    pause
    exit /b 1
)

echo Current directory: %CD%
echo.

echo Checking Flutter installation...
flutter --version
if errorlevel 1 (
    echo.
    echo ========================================
    echo ERROR: Flutter is not installed or not in PATH!
    echo ========================================
    echo.
    echo Solutions:
    echo 1. Install Flutter from: https://flutter.dev/docs/get-started/install/windows
    echo 2. Add Flutter to your PATH: C:\flutter\bin
    echo 3. Restart your computer after adding to PATH
    echo.
    echo To check if Flutter is in PATH, run: flutter --version
    echo.
    pause
    exit /b 1
)

echo.
echo Flutter found! Continuing...
echo.
pause

echo Step 1: Getting dependencies...
echo This may take a few minutes...
call flutter pub get
if errorlevel 1 (
    echo.
    echo ERROR: Failed to get dependencies
    echo Check your internet connection and try again.
    echo.
    pause
    exit /b 1
)
echo Step 1 completed successfully!
echo.
pause

echo Step 2: Generating code (Hive adapters)...
echo This may take a minute...
call flutter pub run build_runner build --delete-conflicting-outputs
if errorlevel 1 (
    echo.
    echo WARNING: Code generation had some issues
    echo Trying to continue anyway...
    echo.
    pause
)
echo Step 2 completed!
echo.
pause

echo Step 3: Building APK...
echo This will take several minutes, please wait...
echo.
call flutter build apk --debug
if errorlevel 1 (
    echo.
    echo ========================================
    echo ERROR: APK build failed!
    echo ========================================
    echo.
    echo Troubleshooting steps:
    echo 1. Run: flutter doctor
    echo 2. Make sure Android SDK is installed
    echo 3. Check if you have enough disk space
    echo 4. Try: flutter clean
    echo 5. Then run this script again
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo APK Build Successful!
echo ========================================
echo.

REM Check if APK exists
if exist "build\app\outputs\flutter-apk\app-debug.apk" (
    for %%F in ("build\app\outputs\flutter-apk\app-debug.apk") do (
        set APK_SIZE=%%~zF
        set /a APK_SIZE_MB=!APK_SIZE!/1048576
        echo APK Location: %CD%\build\app\outputs\flutter-apk\app-debug.apk
        echo APK Size: !APK_SIZE_MB! MB
        echo Created: %%~tF
    )
) else (
    echo WARNING: APK file not found at expected location!
    echo Please check the build output above for errors.
)

echo.
echo ========================================
echo Next Steps:
echo ========================================
echo 1. Find the APK at: app\build\app\outputs\flutter-apk\app-debug.apk
echo 2. Transfer APK to your Android phone (USB, email, cloud)
echo 3. On phone: Enable "Install from Unknown Sources"
echo 4. Tap the APK file to install
echo 5. Open app and enter server URL: http://192.168.18.165:8000
echo.
echo Make sure your Django server is running!
echo Server URL: http://192.168.18.165:8000
echo.

pause

