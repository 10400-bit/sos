import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/emergency_service.dart';
import 'sos_sending_screen.dart';

class EmergencyTypeScreen extends StatefulWidget {
  final String? initialType;

  const EmergencyTypeScreen({super.key, this.initialType});

  @override
  State<EmergencyTypeScreen> createState() => _EmergencyTypeScreenState();
}

class _EmergencyTypeScreenState extends State<EmergencyTypeScreen> {
  String? _selectedType;
  final _descriptionController = TextEditingController();

  final List<Map<String, dynamic>> _emergencyTypes = [
    {
      'type': 'accident',
      'icon': Icons.car_crash,
      'label': 'Accident',
      'color': Color(0xFFEF4444),
    },
    {
      'type': 'fire',
      'icon': Icons.local_fire_department,
      'label': 'Fire',
      'color': Color(0xFFFF6B35),
    },
    {
      'type': 'medical',
      'icon': Icons.local_hospital,
      'label': 'Medical',
      'color': Color(0xFF3B82F6),
    },
    {
      'type': 'criminal',
      'icon': Icons.security,
      'label': 'Criminal Activity',
      'color': Color(0xFFDC2626),
    },
    {
      'type': 'disaster',
      'icon': Icons.warning,
      'label': 'Disaster',
      'color': Color(0xFFFF9800),
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _proceed() {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an emergency type'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SOSSendingScreen(
          emergencyType: _selectedType!,
          description: _descriptionController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Emergency Type'),
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'What type of emergency?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                // Emergency Type Cards
                ..._emergencyTypes.map((type) {
                  bool isSelected = _selectedType == type['type'];
                  Color color = type['color'] as Color;

                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedType = type['type']);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? color : Colors.grey.withOpacity(0.3),
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              type['icon'] as IconData,
                              color: color,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              type['label'] as String,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? color : Colors.white,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_circle, color: color, size: 28),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 30),

                // Description Field
                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Describe the emergency situation...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.1),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),

                const SizedBox(height: 30),

                // Proceed Button
                ElevatedButton(
                  onPressed: _proceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'SEND EMERGENCY ALERT',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
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
}

