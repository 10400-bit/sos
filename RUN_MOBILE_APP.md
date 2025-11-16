# 📱 How to Run SOS System on Mobile - Step by Step

## 🚀 Quick Start (3 Methods)

---

## Method 1: Build APK File (Recommended for Testing)

### Prerequisites Check
First, check if Flutter is installed:
```bash
flutter --version
```

**If Flutter is NOT installed:**
1. Download Flutter: https://flutter.dev/docs/get-started/install/windows
2. Extract to `C:\flutter` (or any location)
3. Add to PATH: `C:\flutter\bin`
4. Restart terminal

### Step-by-Step Build Process

**1. Open Command Prompt or PowerShell**
```cmd
cd "C:\Users\GIB\OneDrive\Desktop\accident system\app"
```

**2. Install Dependencies**
```bash
flutter pub get
```

**3. Generate Required Code**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**4. Build APK**
```bash
flutter build apk --debug
```

**5. Find Your APK**
The APK will be at:
```
C:\Users\GIB\OneDrive\Desktop\accident system\app\build\app\outputs\flutter-apk\app-debug.apk
```

**6. Install on Phone**

**Option A: USB Transfer**
- Connect phone via USB
- Copy APK to phone
- Open file manager on phone
- Tap APK and install

**Option B: Email/Cloud**
- Email APK to yourself
- Download on phone
- Install

**Option C: ADB (if USB debugging enabled)**
```bash
adb install app\build\app\outputs\flutter-apk\app-debug.apk
```

**7. Enable Installation**
- On Android phone: Settings → Security → Enable "Install from Unknown Sources"
- Or: Settings → Apps → Special Access → Install Unknown Apps

---

## Method 2: Run Directly (If Flutter Installed)

**1. Connect Android Device**
- Connect via USB
- Enable USB Debugging (Settings → Developer Options)
- Or use Android Emulator

**2. Check Device**
```bash
cd "C:\Users\GIB\OneDrive\Desktop\accident system\app"
flutter devices
```

**3. Run App**
```bash
flutter run
```

The app will install and launch automatically!

---

## Method 3: Using Android Studio (Easiest GUI Method)

**1. Open Project**
- Open Android Studio
- File → Open → Select `app` folder
- Wait for indexing

**2. Connect Device**
- Connect Android phone via USB
- Enable USB Debugging
- Device should appear in toolbar

**3. Run**
- Click green "Run" button (▶️)
- Or press `Shift + F10`
- App will build and install automatically

---

## ⚙️ Configure App After Installation

### Step 1: Ensure Server is Running
```bash
# In project root, double-click:
start_server.bat
```

Or manually:
```bash
cd backend
venv\Scripts\activate
python manage.py runserver 0.0.0.0:8000
```

### Step 2: Find Your PC's IP Address
```bash
ipconfig
```
Look for "IPv4 Address" (e.g., `192.168.18.165`)

### Step 3: Connect Phone to Same WiFi
- Make sure phone and PC are on the same WiFi network

### Step 4: Open App and Register

1. **Launch App** on your phone
2. **Enter Server URL**: `http://192.168.18.165:8000` (use your actual IP)
3. **Fill Registration Form**:
   - Name
   - Phone number
   - Blood group
   - Emergency contact 1
   - Emergency contact 2 (optional)
   - Vehicle number
4. **Tap "Register"**
5. **View QR Code** - Save it!

---

## 🆘 Using the SOS System

### Send Emergency Alert

1. **Tap the big SOS button** on home screen
2. **Select Emergency Type**:
   - 🚗 Accident
   - 🔥 Fire
   - 🏥 Medical
   - 🚨 Criminal Activity
   - 🌊 Disaster
3. **(Optional) Add Description** - AI will classify automatically
4. **Tap "SEND EMERGENCY ALERT"**

### What Happens Automatically:

✅ **GPS Location** - Captured automatically  
✅ **Alert Sent** - To Django server  
✅ **Auto-Call** - Calls police (100) and guardian  
✅ **Auto-SMS** - Opens SMS app with pre-filled message  

### Verify on Dashboard

Open browser: `http://192.168.18.165:8000`
- Check "Recent Emergency Alerts"
- Your alert should appear with timestamp and location!

---

## 🔧 Troubleshooting

### "Flutter not found"
- Install Flutter: https://flutter.dev/docs/get-started/install/windows
- Add to PATH: `C:\flutter\bin`
- Restart terminal

### "Cannot connect to server"
- ✅ Server running? Check http://127.0.0.1:8000
- ✅ Same WiFi? Phone and PC must be on same network
- ✅ Correct IP? Use `ipconfig` to find PC's IP
- ✅ Firewall? Allow port 8000 in Windows Firewall

### "Build failed"
```bash
cd app
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter build apk --debug
```

### "GPS not working"
- Grant location permission when app asks
- Enable location services: Settings → Location
- Check app permissions

### "Auto-call/SMS not working"
- Grant phone permission
- Grant SMS permission
- Some devices need manual permission grants

### "App crashes on launch"
- Check Flutter version: `flutter --version`
- Clean build: `flutter clean && flutter pub get`
- Rebuild: `flutter build apk --debug`

---

## 📋 Quick Command Cheat Sheet

```bash
# Navigate to app
cd "C:\Users\GIB\OneDrive\Desktop\accident system\app"

# Get dependencies
flutter pub get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Build APK
flutter build apk --debug

# Run on device
flutter run

# Check devices
flutter devices

# Clean build
flutter clean
```

---

## ✅ Testing Checklist

After installation, test:

- [ ] App opens without crashing
- [ ] Registration form works
- [ ] QR code displays after registration
- [ ] SOS button is visible and animated
- [ ] Emergency type selection works
- [ ] Alert sends successfully
- [ ] Alert appears on dashboard
- [ ] GPS coordinates captured
- [ ] Auto-call works (opens dialer)
- [ ] Auto-SMS works (opens SMS app)

---

## 🎯 Your Server Info

**Current Server IP**: `192.168.18.165`  
**Server URL for App**: `http://192.168.18.165:8000`  
**Dashboard URL**: `http://192.168.18.165:8000`

---

**Need Help?** Check `MOBILE_SETUP.md` for more details!

