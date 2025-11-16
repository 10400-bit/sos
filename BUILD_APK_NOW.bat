@echo off
title Building Emergency Response APK
color 0A

echo.
echo ============================================================
echo    EMERGENCY RESPONSE SYSTEM - APK BUILDER
echo ============================================================
echo.

REM Get the directory where this batch file is located
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%app"

if not exist "pubspec.yaml" (
    echo ERROR: Cannot find app directory!
    echo Make sure this file is in the project root.
    pause
    exit /b 1
)

echo Current directory: %CD%
echo.

REM Step 1: Get dependencies
echo ============================================================
echo [STEP 1/4] Getting Flutter dependencies...
echo ============================================================
call flutter pub get
if errorlevel 1 (
    echo.
    echo ERROR: Failed to get dependencies!
    echo Check your internet connection.
    pause
    exit /b 1
)
echo.
echo ✓ Dependencies installed successfully!
echo.
timeout /t 2 /nobreak >nul

REM Step 2: Generate code
echo ============================================================
echo [STEP 2/4] Generating code (Hive adapters)...
echo ============================================================
call flutter pub run build_runner build --delete-conflicting-outputs
if errorlevel 1 (
    echo.
    echo WARNING: Code generation had issues, but continuing...
    echo.
)
echo.
echo ✓ Code generation completed!
echo.
timeout /t 2 /nobreak >nul

REM Step 3: Build APK
echo ============================================================
echo [STEP 3/4] Building APK (this will take 2-5 minutes)...
echo ============================================================
echo Please wait, this is the longest step...
echo.
call flutter build apk --debug
if errorlevel 1 (
    echo.
    echo ============================================================
    echo ERROR: APK build failed!
    echo ============================================================
    echo.
    echo Try these solutions:
    echo 1. Run: flutter doctor
    echo 2. Make sure Android SDK is installed
    echo 3. Check disk space
    echo 4. Try: flutter clean
    echo.
    pause
    exit /b 1
)
echo.
echo ✓ APK build completed!
echo.
timeout /t 2 /nobreak >nul

REM Step 4: Verify APK
echo ============================================================
echo [STEP 4/4] Verifying APK...
echo ============================================================
if exist "build\app\outputs\flutter-apk\app-debug.apk" (
    for %%F in ("build\app\outputs\flutter-apk\app-debug.apk") do (
        set "APK_PATH=%%~fF"
        set "APK_SIZE=%%~zF"
    )
    
    set /a SIZE_MB=%APK_SIZE% / 1048576
    
    echo.
    echo ============================================================
    echo    ✓✓✓ APK BUILD SUCCESSFUL! ✓✓✓
    echo ============================================================
    echo.
    echo APK Location:
    echo   %APK_PATH%
    echo.
    echo APK Size: %SIZE_MB% MB
    echo.
    echo ============================================================
    echo    NEXT STEPS:
    echo ============================================================
    echo.
    echo 1. Copy the APK to your Android phone:
    echo    - USB transfer
    echo    - Email to yourself
    echo    - Cloud storage (Google Drive, etc.)
    echo.
    echo 2. On your phone:
    echo    - Go to Settings ^> Security
    echo    - Enable "Install from Unknown Sources"
    echo.
    echo 3. Install the APK:
    echo    - Open file manager on phone
    echo    - Tap the APK file
    echo    - Tap "Install"
    echo.
    echo 4. Open the app and enter server URL:
    echo    http://192.168.18.165:8000
    echo.
    echo ============================================================
    echo.
) else (
    echo.
    echo ERROR: APK file not found!
    echo Expected location: build\app\outputs\flutter-apk\app-debug.apk
    echo.
    echo Please check the build output above for errors.
    echo.
)

pause

