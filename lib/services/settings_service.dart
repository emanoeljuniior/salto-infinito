import 'package:shared_preferences/shared_preferences.dart';

/// Persiste as preferências do jogador (ex.: som ligado/desligado).
class SettingsService {
  static const _soundEnabledKey = 'sound_enabled';

  Future<bool> isSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_soundEnabledKey) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, enabled);
  }
}
