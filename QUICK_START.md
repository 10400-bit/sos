# ⚡ Quick Start Guide

Get the Emergency Response System running in 5 minutes!

## 🚀 Step 1: Start Django Server (30 seconds)

**Windows:**
- Double-click `start_server.bat`
- Wait for "Starting development server at..."
- Note your PC's IP address (run `ipconfig` in CMD)

**Manual:**
```bash
cd backend
python -m venv venv
venv\Scripts\activate  # Windows
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
```

## 📱 Step 2: Build & Install Flutter App (3 minutes)

```bash
cd app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter build apk --debug
```

**Install APK:**
- Transfer `app/build/app/outputs/flutter-apk/app-debug.apk` to your phone
- Enable "Install from Unknown Sources"
- Install the APK

## 🔗 Step 3: Connect (1 minute)

1. **Find your PC's IP:**
   - Windows: `ipconfig` → Look for "IPv4 Address"
   - Example: `192.168.1.100`

2. **Connect phone to same WiFi as PC**

3. **Open app and enter server URL:**
   - `http://YOUR_IP:8000`
   - Example: `http://192.168.1.100:8000`

## ✅ Step 4: Test (30 seconds)

1. **Register a user:**
   - Fill in the form
   - Tap "Register"
   - View your QR code

2. **Send test alert:**
   - Tap SOS button
   - Select "Accident"
   - Tap "SEND EMERGENCY ALERT"
   - Check dashboard at `http://YOUR_IP:8000`

## 🎯 That's It!

Your system is now running. Check the dashboard to see alerts in real-time!

## 🆘 Troubleshooting

**Can't connect?**
- Check PC and phone are on same WiFi
- Verify server is running on `0.0.0.0:8000`
- Check Windows Firewall

**App crashes?**
- Run `flutter clean` and rebuild
- Check permissions in Android settings

**No alerts showing?**
- Check server logs for errors
- Verify mobile app has internet permission
- Test with browser: `http://YOUR_IP:8000`

---

**Need help?** Check `README.md` for detailed instructions.

