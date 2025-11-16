import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../services/emergency_service.dart';
import 'emergency_type_screen.dart';
import 'register_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showSOS() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EmergencyTypeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = StorageService.getCurrentUser();

    return Scaffold(
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
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Emergency',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          user?.name ?? 'User',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white70),
                      onPressed: () {
                        StorageService.clearUser();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // SOS Button
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return GestureDetector(
                        onTap: _showSOS,
                        child: Container(
                          width: 250 * _pulseAnimation.value,
                          height: 250 * _pulseAnimation.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFEF4444).withOpacity(0.6),
                                blurRadius: 40 * _pulseAnimation.value,
                                spreadRadius: 20 * _pulseAnimation.value,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.warning_rounded,
                                  size: 80,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'SOS',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 4,
                                  ),
                                ),
                                const Text(
                                  'Tap for Emergency',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Quick Actions
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildQuickAction(
                      icon: Icons.local_hospital,
                      label: 'Medical',
                      color: const Color(0xFF3B82F6),
                      onTap: () => _navigateToEmergency('medical'),
                    ),
                    _buildQuickAction(
                      icon: Icons.local_fire_department,
                      label: 'Fire',
                      color: const Color(0xFFFF6B35),
                      onTap: () => _navigateToEmergency('fire'),
                    ),
                    _buildQuickAction(
                      icon: Icons.car_crash,
                      label: 'Accident',
                      color: const Color(0xFFEF4444),
                      onTap: () => _navigateToEmergency('accident'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToEmergency(String type) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EmergencyTypeScreen(initialType: type),
      ),
    );
  }
}

