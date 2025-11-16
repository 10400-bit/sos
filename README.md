# 🚨 Offline Emergency Response System

A complete offline emergency response system consisting of a Django backend (PC) and Flutter mobile app (Android) that works entirely without internet connectivity using local WiFi/LAN.

## 📋 Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
  - [Django Backend Setup](#django-backend-setup)
  - [Flutter App Setup](#flutter-app-setup)
- [Usage Guide](#usage-guide)
- [Building APK](#building-apk)
- [Network Configuration](#network-configuration)
- [Troubleshooting](#troubleshooting)

## ✨ Features

### 🖥️ Django Backend (PC)
- ✅ User registration with QR code generation
- ✅ Real-time emergency alert dashboard
- ✅ QR code scan logging
- ✅ Emergency alert management
- ✅ Beautiful TailwindCSS UI
- ✅ SQLite database (no external dependencies)
- ✅ Fully offline operation

### 📱 Flutter Mobile App (Android)
- ✅ Beautiful dark/neon emergency UI
- ✅ Animated SOS button with pulse effect
- ✅ Emergency type selection (Accident, Fire, Medical, Criminal, Disaster)
- ✅ Offline AI classification (keyword-based)
- ✅ GPS location tracking (offline)
- ✅ Auto-call emergency services
- ✅ Auto-SMS to contacts
- ✅ QR code display for user identification
- ✅ Local storage with Hive
- ✅ LAN communication with Django backend

## 📁 Project Structure

```
project/
├── backend/                 # Django backend
│   ├── emergency/          # Main app
│   ├── emergency_system/   # Project settings
│   ├── templates/          # HTML templates
│   ├── static/             # Static files
│   ├── media/              # Media files
│   ├── manage.py
│   └── requirements.txt
├── app/                    # Flutter mobile app
│   ├── lib/
│   │   ├── models/         # Data models
│   │   ├── screens/       # UI screens
│   │   └── services/      # Business logic
│   ├── android/            # Android configuration
│   └── pubspec.yaml
├── qr_codes/              # Generated QR codes
├── start_server.bat       # Windows auto-start script
└── README.md
```

## 🔧 Prerequisites

### For Django Backend:
- Python 3.8 or higher
- pip (Python package manager)
- Windows OS (for .bat file)

### For Flutter App:
- Flutter SDK (latest stable version)
- Android Studio
- Android SDK (API level 21+)
- Java JDK 11 or higher

## 🚀 Setup Instructions

### Django Backend Setup

1. **Navigate to backend directory:**
   ```bash
   cd backend
   ```

2. **Create virtual environment:**
   ```bash
   python -m venv venv
   ```

3. **Activate virtual environment:**
   - **Windows:**
     ```bash
     venv\Scripts\activate
     ```
   - **Linux/Mac:**
     ```bash
     source venv/bin/activate
     ```

4. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

5. **Run migrations:**
   ```bash
   python manage.py migrate
   ```

6. **Create superuser (optional, for admin access):**
   ```bash
   python manage.py createsuperuser
   ```

7. **Start the server:**
   ```bash
   python manage.py runserver
   ```
   
   Or simply **double-click `start_server.bat`** from the project root!

8. **Access the application:**
   - Dashboard: http://127.0.0.1:8000/
   - Admin Panel: http://127.0.0.1:8000/admin/

### Flutter App Setup

1. **Navigate to app directory:**
   ```bash
   cd app
   ```

2. **Get Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters:**
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

   Or open the project in Android Studio and click "Run".

## 📱 Usage Guide

### First Time Setup

1. **Start Django Server:**
   - Double-click `start_server.bat` or run manually
   - Note your PC's IP address (e.g., 192.168.1.100)

2. **Register User on Mobile App:**
   - Open the Flutter app
   - Enter server URL: `http://YOUR_PC_IP:8000` (e.g., `http://192.168.1.100:8000`)
   - Fill in registration form:
     - Name
     - Phone number
     - Blood group
     - Emergency contacts (2 contacts)
     - Vehicle number
   - Tap "Register"
   - Save your QR code (screenshot or print)

3. **Using Emergency Features:**
   - Tap the big SOS button on home screen
   - Select emergency type
   - (Optional) Add description for AI classification
   - Tap "SEND EMERGENCY ALERT"
   - App will:
     - Get GPS coordinates
     - Send alert to Django server
     - Auto-call police and guardian
     - Auto-send SMS to emergency contacts

### Emergency Types

- **Accident**: Vehicle crashes, road accidents
- **Fire**: Fire emergencies, burning incidents
- **Medical**: Health emergencies, medical issues
- **Criminal Activity**: Attacks, theft, violence
- **Disaster**: Natural disasters, floods, earthquakes

### AI Classification

The app uses keyword-based offline classification:
- **Accident**: crash, hit, bike, bleeding, road, fall
- **Fire**: fire, burn, smoke, flame
- **Criminal**: knife, attack, robbery, theft
- **Medical**: pain, breathing, heart, unconscious
- **Disaster**: flood, earthquake, storm

## 📦 Building APK

### Debug APK (for testing):

```bash
cd app
flutter build apk --debug
```

APK location: `app/build/app/outputs/flutter-apk/app-debug.apk`

### Release APK (for distribution):

1. **Update version in `pubspec.yaml`:**
   ```yaml
   version: 1.0.0+1
   ```

2. **Build release APK:**
   ```bash
   cd app
   flutter build apk --release
   ```

3. **APK location:**
   `app/build/app/outputs/flutter-apk/app-release.apk`

### Install APK on Device:

```bash
adb install app-release.apk
```

Or transfer the APK file to your Android device and install manually.

## 🌐 Network Configuration

### Setting Up Local Network

1. **Find your PC's IP address:**
   - **Windows:** Open Command Prompt, type `ipconfig`
   - Look for "IPv4 Address" (e.g., 192.168.1.100)

2. **Connect Mobile to Same Network:**
   - Connect Android device to same WiFi network as PC
   - Or create a mobile hotspot on PC and connect phone to it

3. **Update Django Settings:**
   - Edit `backend/emergency_system/settings.py`
   - Add your PC's IP to `ALLOWED_HOSTS`:
     ```python
     ALLOWED_HOSTS = ['*']  # Already configured for local network
     ```

4. **Start Django Server:**
   ```bash
   python manage.py runserver 0.0.0.0:8000
   ```
   This makes the server accessible from other devices on the network.

5. **Configure Mobile App:**
   - Enter server URL: `http://YOUR_PC_IP:8000`
   - Example: `http://192.168.1.100:8000`

## 🔍 Troubleshooting

### Django Backend Issues

**Problem: Server not accessible from mobile**
- Solution: Use `0.0.0.0:8000` instead of `127.0.0.1:8000`
- Check Windows Firewall settings
- Ensure PC and mobile are on same network

**Problem: QR codes not generating**
- Solution: Check `qr_codes/` folder exists and has write permissions
- Verify Pillow library is installed correctly

**Problem: Database errors**
- Solution: Run `python manage.py migrate` again
- Delete `db.sqlite3` and re-run migrations

### Flutter App Issues

**Problem: App crashes on launch**
- Solution: Run `flutter clean` and `flutter pub get`
- Check Android permissions in `AndroidManifest.xml`

**Problem: GPS not working**
- Solution: Grant location permissions when prompted
- Check device location services are enabled

**Problem: Cannot connect to server**
- Solution: Verify server URL is correct
- Check PC and mobile are on same network
- Try pinging PC IP from mobile terminal

**Problem: Auto-call/SMS not working**
- Solution: Grant phone and SMS permissions
- Some devices require manual permission grants in settings

**Problem: Hive errors**
- Solution: Run `flutter pub run build_runner build --delete-conflicting-outputs`
- Clear app data and reinstall

### Network Issues

**Problem: Connection timeout**
- Solution: Check firewall settings
- Verify server is running on correct IP
- Try disabling VPN if active

**Problem: CORS errors**
- Solution: Already configured in Django settings
- If issues persist, check `django-cors-headers` is installed

## 📝 API Endpoints

### Emergency Report
```
POST http://YOUR_IP:8000/emergency/report/
Content-Type: application/json

{
  "user_id": "uuid",
  "type": "accident",
  "gps": "27.23421, 80.32143",
  "severity": "high",
  "description": "Car crash on highway"
}
```

### QR Code Scan
```
POST http://YOUR_IP:8000/api/scan-qr/
Content-Type: application/json

{
  "user_id": "uuid",
  "scanner_info": "Scanner device info"
}
```

## 🎨 UI Preview

### Mobile App Screens:
1. **Splash Screen**: Animated emergency logo
2. **Registration**: Clean form with all user fields
3. **QR Display**: Large QR code with user info
4. **Home Screen**: Big pulsing SOS button with quick actions
5. **Emergency Type**: Card-based selection with icons
6. **Sending Screen**: Animated alert sending with status

### Web Dashboard:
- Dark theme with TailwindCSS
- Real-time alert updates
- Statistics cards
- Alert management table
- QR scan logs

## 🔒 Security Notes

- This system is designed for **offline/local network use only**
- No external APIs or internet required
- All data stored locally (SQLite + Hive)
- Suitable for hackathons and local deployments
- **Not recommended for production without additional security**

## 📄 License

This project is created for hackathon/demonstration purposes.

## 🤝 Contributing

Feel free to fork and enhance:
- Add more emergency types
- Improve AI classification
- Add map visualization
- Enhance UI/UX
- Add notification system

## 📞 Support

For issues or questions:
1. Check Troubleshooting section
2. Review Django/Flutter logs
3. Verify network configuration
4. Test with sample data

---

**Built with ❤️ for Emergency Response**

*Stay Safe! 🚨*

