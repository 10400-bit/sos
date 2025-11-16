import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import '../services/storage_service.dart';
import 'home_screen.dart';

class QRDisplayScreen extends StatelessWidget {
  const QRDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = StorageService.getCurrentUser();

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user data found')),
      );
    }

    // Create QR data as JSON string
    final qrData = jsonEncode({
      'user_id': user.id,
      'name': user.name,
      'phone': user.phone,
      'blood_group': user.bloodGroup,
      'vehicle_number': user.vehicleNumber,
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your QR Code'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E293B),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Registration Complete!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Save this QR code for emergency identification',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // QR Code
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 250,
                    backgroundColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),

                // User Info Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Name', user.name),
                      const SizedBox(height: 10),
                      _buildInfoRow('Phone', user.phone),
                      const SizedBox(height: 10),
                      _buildInfoRow('Blood Group', user.bloodGroup),
                      const SizedBox(height: 10),
                      _buildInfoRow('Vehicle', user.vehicleNumber),
                      const SizedBox(height: 10),
                      _buildInfoRow('Emergency Contact', user.emergencyContact1),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue to Home',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

