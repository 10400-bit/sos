import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../models/user_model.dart';
import 'storage_service.dart';
import 'ai_classifier.dart';

class EmergencyService extends ChangeNotifier {
  String? _serverUrl;
  bool _isSending = false;

  String? get serverUrl => _serverUrl;
  bool get isSending => _isSending;

  void setServerUrl(String url) {
    _serverUrl = url;
    notifyListeners();
  }

  Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> sendEmergencyAlert({
    required String emergencyType,
    String? description,
    String? severity,
  }) async {
    _isSending = true;
    notifyListeners();

    try {
      // Get current location
      Position? position = await getCurrentLocation();
      String gps = position != null
          ? "${position.latitude},${position.longitude}"
          : "0.0,0.0";

      // Get user from storage
      UserModel? user = StorageService.getCurrentUser();
      if (user == null || user.serverUserId == null) {
        throw Exception("User not registered on server");
      }

      // Classify emergency if description provided
      if (description != null && description.isNotEmpty) {
        String classified = AIClassifier.classify(description);
        if (classified != emergencyType) {
          emergencyType = classified;
        }
      }

      // Determine severity if not provided
      severity ??= _determineSeverity(emergencyType);

      // Prepare payload
      Map<String, dynamic> payload = {
        'user_id': user.serverUserId,
        'type': emergencyType,
        'gps': gps,
        'severity': severity,
        'description': description ?? '',
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Send to server
      if (_serverUrl != null && _serverUrl!.isNotEmpty) {
        final url = Uri.parse('$_serverUrl/emergency/report/');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(payload),
        ).timeout(const Duration(seconds: 5));

        if (response.statusCode != 200) {
          throw Exception("Server error: ${response.statusCode}");
        }
      }

      // Auto-call emergency services
      await _makeEmergencyCalls(user, emergencyType);

      // Auto-send SMS
      await _sendEmergencySMS(user, emergencyType, gps);

      _isSending = false;
      notifyListeners();
    } catch (e) {
      _isSending = false;
      notifyListeners();
      rethrow;
    }
  }

  String _determineSeverity(String type) {
    switch (type) {
      case 'accident':
      case 'fire':
      case 'criminal':
        return 'high';
      case 'medical':
        return 'high';
      case 'disaster':
        return 'critical';
      default:
        return 'high';
    }
  }

  Future<void> _makeEmergencyCalls(UserModel user, String emergencyType) async {
    // Call police (100 in India, 911 in US - adjust as needed)
    String policeNumber = '100';
    String guardianNumber = user.emergencyContact1;

    try {
      // Call police
      final policeUri = Uri.parse('tel:$policeNumber');
      if (await canLaunchUrl(policeUri)) {
        await launchUrl(policeUri);
      }

      // Wait a bit before calling guardian
      await Future.delayed(const Duration(seconds: 2));

      // Call guardian
      final guardianUri = Uri.parse('tel:$guardianNumber');
      if (await canLaunchUrl(guardianUri)) {
        await launchUrl(guardianUri);
      }
    } catch (e) {
      // Silently fail - calls may not work on all devices
    }
  }

  Future<void> _sendEmergencySMS(
    UserModel user,
    String emergencyType,
    String gps,
  ) async {
    String message = _buildEmergencyMessage(user, emergencyType, gps);
    String guardianNumber = user.emergencyContact1;

    try {
      // SMS to guardian
      final smsUri = Uri.parse('sms:$guardianNumber?body=${Uri.encodeComponent(message)}');
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      }

      // SMS to second contact if available
      if (user.emergencyContact2 != null && user.emergencyContact2!.isNotEmpty) {
        await Future.delayed(const Duration(seconds: 1));
        final smsUri2 = Uri.parse('sms:${user.emergencyContact2}?body=${Uri.encodeComponent(message)}');
        if (await canLaunchUrl(smsUri2)) {
          await launchUrl(smsUri2);
        }
      }
    } catch (e) {
      // Silently fail
    }
  }

  String _buildEmergencyMessage(UserModel user, String type, String gps) {
    return '''🚨 EMERGENCY ALERT 🚨

Type: ${type.toUpperCase()}
Name: ${user.name}
Phone: ${user.phone}
Vehicle: ${user.vehicleNumber}
Blood Group: ${user.bloodGroup}
Location: $gps

Please help immediately!''';
  }
}

