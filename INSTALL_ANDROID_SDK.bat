@echo off
title Install Android SDK for Flutter
color 0E

echo.
echo ============================================================
echo    QUICK ANDROID SDK SETUP FOR FLUTTER
echo ============================================================
echo.

REM Check common Android SDK locations
set "SDK_PATH1=%LOCALAPPDATA%\Android\Sdk"
set "SDK_PATH2=%USERPROFILE%\AppData\Local\Android\Sdk"
set "SDK_PATH3=C:\Android\Sdk"
set "ANDROID_STUDIO=%LOCALAPPDATA%\Programs\Android\Android Studio"

echo Checking for existing Android SDK installations...
echo.

if exist "%SDK_PATH1%" (
    echo [FOUND] Android SDK at: %SDK_PATH1%
    set "FOUND_SDK=%SDK_PATH1%"
    goto SETUP_SDK
)

if exist "%SDK_PATH2%" (
    echo [FOUND] Android SDK at: %SDK_PATH2%
    set "FOUND_SDK=%SDK_PATH2%"
    goto SETUP_SDK
)

if exist "%SDK_PATH3%" (
    echo [FOUND] Android SDK at: %SDK_PATH3%
    set "FOUND_SDK=%SDK_PATH3%"
    goto SETUP_SDK
)

if exist "%ANDROID_STUDIO%" (
    echo [FOUND] Android Studio installed
    echo SDK should be at: %SDK_PATH1%
    if not exist "%SDK_PATH1%" (
        echo.
        echo Android Studio is installed but SDK not found.
        echo You need to open Android Studio first to initialize SDK.
        echo.
        goto INSTALL_ANDROID_STUDIO
    )
    set "FOUND_SDK=%SDK_PATH1%"
    goto SETUP_SDK
)

echo [NOT FOUND] No Android SDK detected.
echo.
goto INSTALL_ANDROID_STUDIO

:SETUP_SDK
echo.
echo ============================================================
echo    SETTING UP ANDROID SDK
echo ============================================================
echo.
echo SDK Location: %FOUND_SDK%
echo.

REM Set environment variables
echo Setting ANDROID_HOME environment variable...
setx ANDROID_HOME "%FOUND_SDK%" >nul 2>&1
set ANDROID_HOME=%FOUND_SDK%

echo Setting PATH...
setx PATH "%PATH%;%FOUND_SDK%\platform-tools;%FOUND_SDK%\tools;%FOUND_SDK%\tools\bin" >nul 2>&1

echo.
echo ✓ Environment variables set!
echo.
echo IMPORTANT: You need to RESTART your terminal/computer
echo            for these changes to take effect.
echo.
pause

echo.
echo ============================================================
echo    CHECKING FLUTTER DOCTOR
echo ============================================================
echo.
flutter doctor

echo.
echo ============================================================
echo    ACCEPTING ANDROID LICENSES
echo ============================================================
echo.
echo You need to accept Android licenses.
echo Press 'y' for each license prompt.
echo.
pause

flutter doctor --android-licenses

echo.
echo ============================================================
echo    SETUP COMPLETE!
echo ============================================================
echo.
echo Next steps:
echo 1. RESTART your terminal/computer
echo 2. Run: flutter doctor
echo 3. If all green, run: BUILD_APK_NOW.bat
echo.
pause
exit /b 0

:INSTALL_ANDROID_STUDIO
echo ============================================================
echo    ANDROID SDK NOT FOUND
echo ============================================================
echo.
echo You need to install Android SDK. Here's the FASTEST way:
echo.
echo OPTION 1: Install Android Studio (Recommended)
echo   - Download: https://developer.android.com/studio
echo   - Install (takes 10-15 minutes)
echo   - Open Android Studio once
echo   - It will auto-setup Android SDK
echo   - Run this script again
echo.
echo OPTION 2: Use Online Build (No Installation Needed!)
echo   - See: BUILD_ON_GITHUB.md
echo   - Build APK in cloud for free
echo   - No Android SDK needed
echo.
echo OPTION 3: Install SDK Command Line Tools Only
echo   - Download: https://developer.android.com/studio#command-tools
echo   - Extract to: C:\Android\Sdk
echo   - Run this script again
echo.
pause

echo.
echo Opening Android Studio download page...
start https://developer.android.com/studio

echo.
echo After installing Android Studio:
echo 1. Open it once (to initialize SDK)
echo 2. Run this script again
echo.
pause
exit /b 1


