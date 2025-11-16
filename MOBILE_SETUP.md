# 📱 Mobile App Setup Guide

## Quick Steps to Run SOS System on Android

### Prerequisites
- Flutter SDK installed
- Android Studio installed
- Android device or emulator
- Same WiFi network as your PC

---

## Method 1: Build APK and Install (Recommended)

### Step 1: Navigate to App Directory
```bash
cd "C:\Users\GIB\OneDrive\Desktop\accident system\app"
```

### Step 2: Get Dependencies
```bash
flutter pub get
```

### Step 3: Generate Hive Adapters
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 4: Build Debug APK
```bash
flutter build apk --debug
```

### Step 5: Install on Device

**Option A: Using ADB (if device connected via USB)**
```bash
adb install build\app\outputs\flutter-apk\app-debug.apk
```

**Option B: Manual Installation**
1. Find the APK file at: `app\build\app\outputs\flutter-apk\app-debug.apk`
2. Transfer to your Android phone (USB, email, cloud storage)
3. On your phone:
   - Go to Settings → Security
   - Enable "Install from Unknown Sources" or "Install Unknown Apps"
   - Open file manager and tap the APK file
   - Tap "Install"

---

## Method 2: Run Directly from Flutter (Development)

### Step 1: Connect Device
- Connect Android phone via USB
- Enable USB Debugging on phone
- Or start Android Emulator

### Step 2: Check Device
```bash
cd "C:\Users\GIB\OneDrive\Desktop\accident system\app"
flutter devices
```

### Step 3: Run App
```bash
flutter run
```

---

## Step 3: Configure App

### 1. Start Django Server (if not running)
```bash
cd "C:\Users\GIB\OneDrive\Desktop\accident system"
start_server.bat
```

### 2. Find Your PC's IP Address
- Open Command Prompt
- Type: `ipconfig`
- Look for "IPv4 Address" (e.g., 192.168.18.165)

### 3. Connect Phone to Same WiFi
- Make sure phone and PC are on the same WiFi network

### 4. Open App and Register
1. Open "Emergency Response" app on your phone
2. You'll see the registration screen
3. Enter:
   - **Server URL**: `http://192.168.18.165:8000` (use your PC's IP)
   - **Name**: Your name
   - **Phone**: Your phone number
   - **Blood Group**: Select from dropdown
   - **Emergency Contact 1**: Guardian's phone
   - **Emergency Contact 2**: (Optional) Second contact
   - **Vehicle Number**: Your vehicle number
4. Tap "Register"
5. View your QR code

---

## Step 4: Test Emergency Alert

### Send Test Alert
1. On home screen, tap the big **SOS button**
2. Select emergency type:
   - Accident
   - Fire
   - Medical
   - Criminal Activity
   - Disaster
3. (Optional) Add description
4. Tap **"SEND EMERGENCY ALERT"**
5. App will:
   - Get GPS location
   - Send alert to server
   - Auto-call police (100) and guardian
   - Auto-send SMS to emergency contacts

### Verify on Dashboard
- Open browser: http://192.168.18.165:8000
- Check "Recent Emergency Alerts" section
- Your alert should appear!

---

## Troubleshooting

### App Won't Install
- Enable "Install from Unknown Sources" in Android settings
- Check if APK file is complete
- Try rebuilding: `flutter clean && flutter build apk --debug`

### Can't Connect to Server
- Verify server is running: http://127.0.0.1:8000
- Check PC and phone are on same WiFi
- Verify IP address is correct
- Check Windows Firewall (allow port 8000)

### GPS Not Working
- Grant location permission when app asks
- Enable location services on phone
- Check app permissions in Android settings

### Auto-Call/SMS Not Working
- Grant phone and SMS permissions
- Some devices require manual permission grants
- Check in Settings → Apps → Emergency Response → Permissions

### Build Errors
```bash
# Clean and rebuild
cd app
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter build apk --debug
```

---

## Quick Command Reference

```bash
# Build APK
cd app
flutter build apk --debug

# Run on connected device
flutter run

# Check devices
flutter devices

# Clean build
flutter clean

# Get dependencies
flutter pub get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Features to Test

✅ **Registration**
- Fill form and register
- View QR code

✅ **Emergency Alert**
- Tap SOS button
- Select emergency type
- Send alert
- Check dashboard

✅ **GPS Location**
- Verify coordinates are captured
- Check on dashboard

✅ **Auto-Call**
- Should call police (100) and guardian
- Verify calls are made

✅ **Auto-SMS**
- Should open SMS app with pre-filled message
- Send to emergency contacts

---

**Your SOS system is now ready to use! 🚨**

