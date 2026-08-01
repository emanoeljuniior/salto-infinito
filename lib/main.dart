import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/ads_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SaltoInfinitoApp());
  // Consentimento (UMP) + inicialização do AdMob rodam em segundo plano,
  // sem bloquear a primeira tela do app.
  AdsService.instance.initialize();
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
