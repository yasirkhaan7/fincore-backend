import 'package:flutter/material.dart';
import 'login_screen.dart'; // 1. Pointing to the new front door

void main() {
  runApp(const FinCoreApp());
}

class FinCoreApp extends StatelessWidget {
  const FinCoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinCore ERP',
      debugShowCheckedModeBanner: false, // Hides the annoying "DEBUG" banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF588157)),
        useMaterial3: true,
      ),
      home: const LoginScreen(), // 2. The app now starts at the Login Screen!
    );
  }
}