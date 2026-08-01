import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const SaltoInfinitoApp());
}

class SaltoInfinitoApp extends StatelessWidget {
  const SaltoInfinitoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salto Infinito',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: const HomeScreen(),
    );
  }
}
