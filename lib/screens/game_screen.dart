import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/salto_game.dart';
import '../services/score_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final ScoreService _scoreService = ScoreService();
  late final SaltoGame _game;

  int _highScore = 0;
  bool _isGameOver = false;
  int _lastScore = 0;
  bool _isNewHighScore = false;

  @override
  void initState() {
    super.initState();
    _game = SaltoGame(onGameOver: _handleGameOver);
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final highScore = await _scoreService.getHighScore();
    if (mounted) {
      setState(() => _highScore = highScore);
    }
  }

  Future<void> _handleGameOver(int score) async {
    final isNewHighScore = await _scoreService.saveIfHighScore(score);
    if (mounted) {
      setState(() {
        _isGameOver = true;
        _lastScore = score;
        _isNewHighScore = isNewHighScore;
        if (isNewHighScore) _highScore = score;
      });
    }
  }

  void _restart() {
    setState(() => _isGameOver = false);
    _game.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A202C),
      body: Stack(
        children: [
          GameWidget(game: _game),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, right: 4),
                    child: Text(
                      'Recorde: $_highScore',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isGameOver)
            _GameOverOverlay(
              score: _lastScore,
              isNewHighScore: _isNewHighScore,
              onRestart: _restart,
              onMenu: () => Navigator.of(context).pop(),
            ),
        ],
      ),
    );
  }
}

class _GameOverOverlay extends StatelessWidget {
  const _GameOverOverlay({
    required this.score,
    required this.isNewHighScore,
    required this.onRestart,
    required this.onMenu,
  });

  final int score;
  final bool isNewHighScore;
  final VoidCallback onRestart;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isNewHighScore)
              const Text(
                'Novo recorde!',
                style: TextStyle(
                  color: Color(0xFF4FD1C5),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              'Pontuação: $score',
              style: const TextStyle(color: Colors.white, fontSize: 28),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onRestart,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4FD1C5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
              ),
              child: const Text('Jogar novamente'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onMenu,
              child: const Text(
                'Menu principal',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
