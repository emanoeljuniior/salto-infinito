import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../services/sound_service.dart';
import 'obstacle.dart';
import 'player.dart';

/// Prototípo jogável do Salto Infinito: um toque = pular, obstáculos
/// gerados proceduralmente, dificuldade crescente, pontuação por distância.
class SaltoGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  SaltoGame({required this.onGameOver});

  final void Function(int score) onGameOver;

  static const double groundHeightFraction = 0.18;
  static const double baseSpeed = 320;
  static const double maxSpeed = 720;
  static const double speedRampPerSecond = 5;
  static const double minObstaclePeriod = 0.65;

  final Random _random = Random();

  late Player player;
  late RectangleComponent ground;
  late TextComponent scoreText;
  late TimerComponent obstacleSpawner;

  double groundY = 0;
  double currentSpeed = baseSpeed;
  double distance = 0;
  bool isGameOver = false;

  int get score => distance ~/ 10;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    groundY = size.y * (1 - groundHeightFraction);

    ground = RectangleComponent(
      position: Vector2(0, groundY),
      size: Vector2(size.x, size.y - groundY),
      paint: Paint()..color = const Color(0xFF2D3748),
    );
    await add(ground);

    player = Player(groundY: groundY);
    await add(player);

    scoreText = TextComponent(
      text: '0',
      position: Vector2(size.x / 2, 24),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    await add(scoreText);

    obstacleSpawner = TimerComponent(
      period: 1.4,
      repeat: true,
      onTick: _spawnObstacle,
    );
    await add(obstacleSpawner);
  }

  void _spawnObstacle() {
    if (isGameOver) return;

    final obstacleHeight = 40.0 + _random.nextInt(40);
    final obstacle = Obstacle(
      position: Vector2(size.x + 20, groundY - obstacleHeight),
      size: Vector2(30, obstacleHeight),
    );
    add(obstacle);

    // Próximo obstáculo em um intervalo aleatório, um pouco mais apertado
    // conforme a dificuldade aumenta, sem nunca ficar impossível de reagir.
    final minPeriod = max(
      minObstaclePeriod,
      1.4 - (currentSpeed - baseSpeed) / 500,
    );
    obstacleSpawner.timer.limit = minPeriod + _random.nextDouble() * 0.6;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) return;

    currentSpeed = min(maxSpeed, currentSpeed + speedRampPerSecond * dt);
    distance += currentSpeed * dt;
    scoreText.text = score.toString();

    for (final obstacle in children.whereType<Obstacle>()) {
      if (player.toRect().overlaps(obstacle.toRect())) {
        _gameOver();
        break;
      }
    }
  }

  void _gameOver() {
    if (isGameOver) return;
    isGameOver = true;
    SoundService.instance.playHit();
    _flashHit();
    onGameOver(score);
  }

  void _flashHit() {
    final flash = RectangleComponent(
      size: size.clone(),
      paint: Paint()..color = const Color(0xFFF56565).withValues(alpha: 0.4),
    );
    flash.add(
      OpacityEffect.fadeOut(
        EffectController(duration: 0.3),
        onComplete: flash.removeFromParent,
      ),
    );
    add(flash);
  }

  /// Reinicia o jogo do zero para uma nova partida.
  void reset() {
    isGameOver = false;
    currentSpeed = baseSpeed;
    distance = 0;
    obstacleSpawner.timer.limit = 1.4;
    player.reset(groundY);
    removeAll(children.whereType<Obstacle>());
  }

  /// Continua a partida atual após a morte (ex.: via anúncio recompensado),
  /// mantendo a pontuação e a velocidade, apenas limpando os obstáculos e
  /// reposicionando o jogador.
  void continueAfterDeath() {
    isGameOver = false;
    player.reset(groundY);
    removeAll(children.whereType<Obstacle>());
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!isGameOver) {
      player.jump();
    }
  }
}
