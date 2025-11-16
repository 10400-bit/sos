# 📦 Build Instructions

## Quick Start

### For Windows Users (Easiest Method)

1. **Start Django Server:**
   - Double-click `start_server.bat`
   - Wait for server to start
   - Note your PC's IP address (run `ipconfig` in CMD)

2. **Build Flutter APK:**
   ```bash
   cd app
   flutter pub get
   flutter build apk --debug
   ```
   APK will be at: `app/build/app/outputs/flutter-apk/app-debug.apk`

3. **Install on Android Device:**
   - Transfer APK to phone
   - Enable "Install from Unknown Sources"
   - Install the APK

## Detailed Build Steps

### Prerequisites Check

**Python & Django:**
```bash
python --version  # Should be 3.8+
pip --version
```

**Flutter:**
```bash
flutter --version
flutter doctor
```

### Step 1: Setup Django Backend

```bash
# Navigate to backend
cd backend

# Create virtual environment
python -m venv venv

# Activate (Windows)
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run migrations
python manage.py migrate

# Start server (accessible from network)
python manage.py runserver 0.0.0.0:8000
```

### Step 2: Build Flutter APK

#### Option A: Debug APK (Testing)
```bash
cd app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter build apk --debug
```

#### Option B: Release APK (Production)
```bash
cd app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter build apk --release
```

### Step 3: Install APK

**Method 1: ADB (Android Debug Bridge)**
```bash
adb install app/build/app/outputs/flutter-apk/app-release.apk
```

**Method 2: Manual Transfer**
1. Copy APK to Android device
2. Open file manager on device
3. Tap APK file
4. Allow installation from unknown sources
5. Install

**Method 3: USB Transfer**
1. Connect phone via USB
2. Enable USB debugging
3. Copy APK to phone
4. Install from phone

## Network Configuration

### Find Your PC's IP Address

**Windows:**
```cmd
ipconfig
```
Look for "IPv4 Address" under your active network adapter.

**Linux/Mac:**
```bash
ifconfig
# or
ip addr
```

### Configure Mobile App

1. Connect Android device to same WiFi as PC
2. Open app
3. Enter server URL: `http://YOUR_PC_IP:8000`
   - Example: `http://192.168.1.100:8000`

### Test Connection

From mobile device, open browser and visit:
```
http://YOUR_PC_IP:8000
```

Should see Django dashboard.

## Troubleshooting Build Issues

### Flutter Build Errors

**Error: "Gradle build failed"**
```bash
cd app/android
./gradlew clean
cd ../..
flutter clean
flutter pub get
flutter build apk
```

**Error: "Hive adapter not found"**
```bash
cd app
flutter pub run build_runner build --delete-conflicting-outputs
```

**Error: "SDK not found"**
- Open Android Studio
- Go to SDK Manager
- Install Android SDK Platform 34
- Install Android SDK Build-Tools

### Django Server Issues

**Error: "Port already in use"**
```bash
# Kill process on port 8000
# Windows:
netstat -ano | findstr :8000
taskkill /PID <PID> /F

# Linux/Mac:
lsof -ti:8000 | xargs kill
```

**Error: "Module not found"**
```bash
cd backend
pip install -r requirements.txt
```

## APK Signing (Optional)

For release distribution:

1. Generate keystore:
```bash
keytool -genkey -v -keystore emergency-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias emergency
```

2. Create `key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=emergency
storeFile=../emergency-release-key.jks
```

3. Update `app/android/app/build.gradle` with signing config.

## Testing Checklist

- [ ] Django server starts successfully
- [ ] Can access dashboard from browser
- [ ] Can register user via web form
- [ ] QR code generates correctly
- [ ] Flutter app builds without errors
- [ ] APK installs on Android device
- [ ] App connects to Django server
- [ ] Registration works from mobile app
- [ ] Emergency alert sends successfully
- [ ] GPS location works
- [ ] Auto-call feature works
- [ ] Auto-SMS feature works

## Performance Tips

1. **Faster Builds:**
   - Use `--debug` for development
   - Use `--release` only for final distribution

2. **Smaller APK:**
   ```bash
   flutter build apk --split-per-abi
   ```
   Creates separate APKs for each architecture.

3. **Optimize Images:**
   - Compress images before adding to assets
   - Use appropriate image formats

## Distribution

### Internal Distribution
- Share APK via email/cloud storage
- Use QR code for easy download
- Host on internal server

### Play Store (Future)
- Sign APK with release key
- Follow Play Store guidelines
- Add privacy policy
- Complete store listing

---

**Happy Building! 🚀**

