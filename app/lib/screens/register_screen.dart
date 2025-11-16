import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../services/emergency_service.dart';
import 'qr_display_screen.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _emergencyContact1Controller = TextEditingController();
  final _emergencyContact2Controller = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _serverUrlController = TextEditingController(text: 'http://192.168.1.100:8000');
  
  String? _selectedBloodGroup;
  bool _isRegistering = false;

  final List<String> _bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isRegistering = true);

    try {
      String serverUrl = _serverUrlController.text.trim();
      if (serverUrl.isEmpty) {
        throw Exception('Server URL is required');
      }

      // Register on server using JSON
      final url = Uri.parse('$serverUrl/register/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'blood_group': _selectedBloodGroup ?? 'O+',
          'emergency_contact_1': _emergencyContact1Controller.text.trim(),
          'emergency_contact_2': _emergencyContact2Controller.text.trim().isEmpty
              ? null
              : _emergencyContact2Controller.text.trim(),
          'vehicle_number': _vehicleNumberController.text.trim(),
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Parse JSON response
        final data = jsonDecode(response.body);
        String userId = data['user_id'] ?? DateTime.now().millisecondsSinceEpoch.toString();
        
        UserModel user = UserModel(
          id: userId,
          name: data['name'] ?? _nameController.text.trim(),
          phone: data['phone'] ?? _phoneController.text.trim(),
          bloodGroup: data['blood_group'] ?? _selectedBloodGroup ?? 'O+',
          emergencyContact1: _emergencyContact1Controller.text.trim(),
          emergencyContact2: _emergencyContact2Controller.text.trim().isEmpty
              ? null
              : _emergencyContact2Controller.text.trim(),
          vehicleNumber: data['vehicle_number'] ?? _vehicleNumberController.text.trim(),
          serverUserId: userId,
        );

        await StorageService.saveUser(user);
        
        // Set server URL in emergency service
        Provider.of<EmergencyService>(context, listen: false).setServerUrl(serverUrl);

        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const QRDisplayScreen()),
        );
      } else {
        throw Exception('Registration failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() => _isRegistering = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bloodGroupController.dispose();
    _emergencyContact1Controller.dispose();
    _emergencyContact2Controller.dispose();
    _vehicleNumberController.dispose();
    _serverUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'User Registration',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              
              // Server URL
              TextFormField(
                controller: _serverUrlController,
                decoration: InputDecoration(
                  labelText: 'Server URL',
                  hintText: 'http://192.168.1.100:8000',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.dns),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Server URL is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _selectedBloodGroup,
                decoration: InputDecoration(
                  labelText: 'Blood Group',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.bloodtype),
                ),
                items: _bloodGroups.map((group) {
                  return DropdownMenuItem(
                    value: group,
                    child: Text(group),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedBloodGroup = value);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Blood group is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _emergencyContact1Controller,
                decoration: InputDecoration(
                  labelText: 'Emergency Contact 1',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.emergency),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Emergency contact is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _emergencyContact2Controller,
                decoration: InputDecoration(
                  labelText: 'Emergency Contact 2 (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.phone_android),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _vehicleNumberController,
                decoration: InputDecoration(
                  labelText: 'Vehicle Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.directions_car),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vehicle number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _isRegistering ? null : _registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isRegistering
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Register',
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
    );
  }
}

