@echo off
title Setting Up Android SDK for Flutter
color 0B

echo.
echo ============================================================
echo    ANDROID SDK AUTO-SETUP FOR FLUTTER
echo ============================================================
echo.
echo This script will help you set up Android SDK automatically.
echo.

REM Check if Android Studio is installed
set "ANDROID_STUDIO_PATH=%LOCALAPPDATA%\Programs\Android\Android Studio"
set "ANDROID_SDK_PATH=%LOCALAPPDATA%\Android\Sdk"

if exist "%ANDROID_SDK_PATH%" (
    echo Found Android SDK at: %ANDROID_SDK_PATH%
    goto SET_ENV
)

if exist "%ANDROID_STUDIO_PATH%" (
    echo Found Android Studio installation.
    set "ANDROID_SDK_PATH=%LOCALAPPDATA%\Android\Sdk"
    goto SET_ENV
)

echo.
echo ============================================================
echo    ANDROID SDK NOT FOUND
echo ============================================================
echo.
echo You need to install Android SDK. Here are your options:
echo.
echo OPTION 1: Install Android Studio (Recommended - Easiest)
echo   1. Download: https://developer.android.com/studio
echo   2. Install Android Studio
echo   3. Open Android Studio
echo   4. Go to: More Actions ^> SDK Manager
echo   5. Install: Android SDK Platform-Tools, Android SDK Build-Tools
echo   6. Run this script again
echo.
echo OPTION 2: Install Android SDK Command Line Tools
echo   1. Download: https://developer.android.com/studio#command-tools
echo   2. Extract to: C:\Android\Sdk
echo   3. Run this script again
echo.
echo OPTION 3: Use Flutter's built-in SDK manager
echo   Run: flutter doctor --android-licenses
echo.
pause
exit /b 1

:SET_ENV
echo.
echo ============================================================
echo    SETTING UP ENVIRONMENT VARIABLES
echo ============================================================
echo.

REM Set ANDROID_HOME for current session
setx ANDROID_HOME "%ANDROID_SDK_PATH%" >nul 2>&1
set ANDROID_HOME=%ANDROID_SDK_PATH%

REM Add to PATH
setx PATH "%PATH%;%ANDROID_SDK_PATH%\platform-tools;%ANDROID_SDK_PATH%\tools" >nul 2>&1

echo ANDROID_HOME set to: %ANDROID_SDK_PATH%
echo.
echo NOTE: You may need to RESTART your terminal/computer
echo       for environment variables to take effect.
echo.
pause

echo.
echo ============================================================
echo    RUNNING FLUTTER DOCTOR
echo ============================================================
echo.
flutter doctor

echo.
echo ============================================================
echo    NEXT STEPS
echo ============================================================
echo.
echo 1. If flutter doctor shows issues, fix them
echo 2. Accept Android licenses: flutter doctor --android-licenses
echo 3. Restart your terminal/computer
echo 4. Run BUILD_APK_NOW.bat again
echo.
pause

