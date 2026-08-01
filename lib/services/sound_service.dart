import 'package:flame_audio/flame_audio.dart';

import 'settings_service.dart';

/// Toca os efeitos sonoros curtos do jogo, respeitando a preferência de
/// som ligado/desligado (persistida via [SettingsService]).
class SoundService {
  SoundService._();

  static final SoundService instance = SoundService._();

  static const jumpSfx = 'jump.wav';
  static const hitSfx = 'hit.wav';
  static const highScoreSfx = 'high_score.wav';

  final SettingsService _settingsService = SettingsService();
  bool _enabled = true;

  bool get isEnabled => _enabled;

  Future<void> initialize() async {
    _enabled = await _settingsService.isSoundEnabled();
    await FlameAudio.audioCache.loadAll([jumpSfx, hitSfx, highScoreSfx]);
  }

  Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
    await _settingsService.setSoundEnabled(enabled);
  }

  void playJump() {
    if (_enabled) FlameAudio.play(jumpSfx);
  }

  void playHit() {
    if (_enabled) FlameAudio.play(hitSfx);
  }

  void playHighScore() {
    if (_enabled) FlameAudio.play(highScoreSfx);
  }
}
