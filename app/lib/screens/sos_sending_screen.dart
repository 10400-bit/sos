import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/emergency_service.dart';
import 'home_screen.dart';

class SOSSendingScreen extends StatefulWidget {
  final String emergencyType;
  final String description;

  const SOSSendingScreen({
    super.key,
    required this.emergencyType,
    required this.description,
  });

  @override
  State<SOSSendingScreen> createState() => _SOSSendingScreenState();
}

class _SOSSendingScreenState extends State<SOSSendingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    _sendEmergency();
  }

  Future<void> _sendEmergency() async {
    try {
      final emergencyService = Provider.of<EmergencyService>(context, listen: false);
      
      await emergencyService.sendEmergencyAlert(
        emergencyType: widget.emergencyType,
        description: widget.description,
      );

      setState(() => _isComplete = true);
      _controller.stop();

      if (!mounted) return;
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      _controller.stop();
      if (!mounted) return;
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to send emergency alert: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getEmergencyLabel() {
    switch (widget.emergencyType) {
      case 'accident':
        return 'ACCIDENT';
      case 'fire':
        return 'FIRE';
      case 'medical':
        return 'MEDICAL';
      case 'criminal':
        return 'CRIMINAL ACTIVITY';
      case 'disaster':
        return 'DISASTER';
      default:
        return 'EMERGENCY';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0F172A),
              const Color(0xFF1E293B),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEF4444).withOpacity(0.6),
                            blurRadius: 40 + (_controller.value * 20),
                            spreadRadius: 20 + (_controller.value * 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _isComplete
                            ? const Icon(
                                Icons.check_circle,
                                size: 100,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.warning_rounded,
                                size: 100,
                                color: Colors.white,
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                Text(
                  _isComplete ? 'ALERT SENT!' : 'SENDING ALERT...',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF4444),
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _getEmergencyLabel(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    letterSpacing: 2,
                  ),
                ),
                if (!_isComplete) ...[
                  const SizedBox(height: 40),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEF4444)),
                  ),
                ],
                if (_isComplete) ...[
                  const SizedBox(height: 20),
                  const Text(
                    'Emergency services have been notified',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

