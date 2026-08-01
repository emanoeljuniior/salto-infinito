import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/ads_service.dart';
import 'services/sound_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SaltoInfinitoApp());
  // Consentimento (UMP) + inicialização do AdMob e pré-carregamento dos
  // efeitos sonoros rodam em segundo plano, sem bloquear a primeira tela.
  AdsService.instance.initialize();
  SoundService.instance.initialize();
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
