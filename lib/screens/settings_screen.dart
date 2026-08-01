import 'package:flutter/material.dart';

import '../services/settings_service.dart';
import '../services/sound_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settingsService = SettingsService();
  bool _soundEnabled = true;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final enabled = await _settingsService.isSoundEnabled();
    if (mounted) {
      setState(() {
        _soundEnabled = enabled;
        _loaded = true;
      });
    }
  }

  Future<void> _toggleSound(bool value) async {
    setState(() => _soundEnabled = value);
    await SoundService.instance.setEnabled(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A202C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
        title: const Text('Configurações'),
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                SwitchListTile(
                  activeThumbColor: const Color(0xFF4FD1C5),
                  title: const Text(
                    'Som',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Efeitos sonoros do jogo',
                    style: TextStyle(color: Colors.white54),
                  ),
                  value: _soundEnabled,
                  onChanged: _toggleSound,
                ),
              ],
            ),
    );
  }
}
