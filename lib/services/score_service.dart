import 'package:shared_preferences/shared_preferences.dart';

/// Persiste o recorde local do jogador entre partidas.
class ScoreService {
  static const _highScoreKey = 'high_score';

  Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highScoreKey) ?? 0;
  }

  /// Salva [score] como novo recorde se ele superar o atual.
  /// Retorna true se um novo recorde foi alcançado.
  Future<bool> saveIfHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final currentHigh = prefs.getInt(_highScoreKey) ?? 0;
    if (score > currentHigh) {
      await prefs.setInt(_highScoreKey, score);
      return true;
    }
    return false;
  }
}
