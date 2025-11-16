# 📊 Sample Data & Test Cases

## Sample User Registration Data

### User 1
```
Name: John Doe
Phone: +1234567890
Blood Group: O+
Emergency Contact 1: +1987654321
Emergency Contact 2: +1555555555
Vehicle Number: ABC-1234
```

### User 2
```
Name: Jane Smith
Phone: +1122334455
Blood Group: A+
Emergency Contact 1: +1999887766
Emergency Contact 2: (empty)
Vehicle Number: XYZ-5678
```

### User 3
```
Name: Bob Johnson
Phone: +1444555666
Blood Group: B-
Emergency Contact 1: +1777888999
Emergency Contact 2: +1666777888
Vehicle Number: DEF-9012
```

## Test Emergency Scenarios

### Test Case 1: Accident Emergency
```
Type: accident
Description: "Car crash on highway, bleeding from head"
Expected Classification: accident
Severity: high
GPS: (will be auto-detected)
```

### Test Case 2: Fire Emergency
```
Type: fire
Description: "Building on fire, smoke everywhere"
Expected Classification: fire
Severity: high
GPS: (will be auto-detected)
```

### Test Case 3: Medical Emergency
```
Type: medical
Description: "Chest pain, difficulty breathing, heart attack"
Expected Classification: medical
Severity: high
GPS: (will be auto-detected)
```

### Test Case 4: Criminal Activity
```
Type: criminal
Description: "Robbery in progress, knife attack"
Expected Classification: criminal
Severity: high
GPS: (will be auto-detected)
```

### Test Case 5: Disaster
```
Type: disaster
Description: "Flood warning, earthquake tremors"
Expected Classification: disaster
Severity: critical
GPS: (will be auto-detected)
```

## API Test Requests

### Register User (JSON)
```bash
curl -X POST http://localhost:8000/register/ \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "phone": "+1234567890",
    "blood_group": "O+",
    "emergency_contact_1": "+1987654321",
    "emergency_contact_2": "+1555555555",
    "vehicle_number": "TEST-1234"
  }'
```

### Report Emergency
```bash
curl -X POST http://localhost:8000/emergency/report/ \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "USER_UUID_HERE",
    "type": "accident",
    "gps": "27.23421, 80.32143",
    "severity": "high",
    "description": "Car crash on highway"
  }'
```

### Scan QR Code
```bash
curl -X POST http://localhost:8000/api/scan-qr/ \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "USER_UUID_HERE",
    "scanner_info": "Mobile Scanner"
  }'
```

## Expected Behaviors

### Registration Flow
1. User fills registration form
2. QR code is generated automatically
3. User data saved to SQLite database
4. QR code saved to `qr_codes/` folder
5. User redirected to QR display page

### Emergency Alert Flow
1. User taps SOS button
2. User selects emergency type
3. (Optional) User adds description
4. App gets GPS coordinates
5. App classifies emergency using AI (if description provided)
6. Alert sent to Django server
7. Auto-call to police (100) and guardian
8. Auto-SMS to emergency contacts
9. Alert appears on dashboard

### QR Code Scan Flow
1. QR code scanned by another device
2. Scan logged in database
3. User information displayed
4. Timestamp recorded

## Database Queries (SQLite)

### View All Users
```sql
SELECT * FROM emergency_user;
```

### View All Alerts
```sql
SELECT * FROM emergency_emergencyalert ORDER BY timestamp DESC;
```

### View QR Scans
```sql
SELECT * FROM emergency_qrscan ORDER BY scanned_at DESC;
```

### Count Alerts by Type
```sql
SELECT emergency_type, COUNT(*) as count 
FROM emergency_emergencyalert 
GROUP BY emergency_type;
```

### Recent Alerts (Last 24 hours)
```sql
SELECT * FROM emergency_emergencyalert 
WHERE timestamp > datetime('now', '-1 day')
ORDER BY timestamp DESC;
```

## Performance Testing

### Load Test (Python)
```python
import requests
import time

url = "http://localhost:8000/emergency/report/"
payload = {
    "user_id": "test-uuid",
    "type": "accident",
    "gps": "27.23421, 80.32143",
    "severity": "high"
}

start = time.time()
for i in range(100):
    requests.post(url, json=payload)
end = time.time()

print(f"100 requests in {end - start} seconds")
```

## Edge Cases to Test

1. **No Internet Connection**
   - App should work offline
   - Alerts queued locally
   - Sync when connection restored

2. **Invalid GPS**
   - App should handle GPS failure gracefully
   - Default to 0.0, 0.0 coordinates

3. **Server Unavailable**
   - App should show error message
   - User can retry sending alert

4. **Empty Description**
   - AI classification should default to selected type
   - No errors should occur

5. **Missing Permissions**
   - Location permission denied
   - Phone/SMS permission denied
   - App should request permissions

6. **Invalid Server URL**
   - App should validate URL format
   - Show clear error message

7. **Duplicate Vehicle Number**
   - Server should reject duplicate
   - Show appropriate error

## Success Criteria

✅ All emergency types can be reported
✅ GPS coordinates are captured
✅ Alerts appear on dashboard within 5 seconds
✅ QR codes generate correctly
✅ Auto-call feature works
✅ Auto-SMS feature works
✅ AI classification works for all keywords
✅ App works offline (local storage)
✅ Server accessible from mobile device
✅ All screens render correctly
✅ Animations are smooth
✅ No crashes or errors

---

**Use these test cases to verify system functionality! 🧪**

