import 'package:flutter/material.dart';
import 'login.dart';
import 'servicios/api.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Api.comprobarConexion();
  runApp(const TechStockApp());
}

class TechStockApp extends StatelessWidget {
  const TechStockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TechStock',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Plus Jakarta Sans',
        scaffoldBackgroundColor: const Color(0xFFFAF8FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00288E),
          primary: const Color(0xFF00288E),
          secondary: const Color(0xFF0051D5),
          surface: Colors.white,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}