import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'services/storage_service.dart';
import 'services/emergency_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  await StorageService.init();
  
  runApp(const EmergencyResponseApp());
}

class EmergencyResponseApp extends StatelessWidget {
  const EmergencyResponseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EmergencyService()),
      ],
      child: MaterialApp(
        title: 'Emergency Response',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFFEF4444),
          scaffoldBackgroundColor: const Color(0xFF0F172A),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFEF4444),
            secondary: Color(0xFF3B82F6),
            error: Color(0xFFEF4444),
          ),
          fontFamily: 'Inter',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

