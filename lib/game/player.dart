import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../services/sound_service.dart';
import 'salto_game.dart';

class Player extends RectangleComponent
    with CollisionCallbacks, HasGameReference<SaltoGame> {
  static const double gravity = 2200;
  static const double jumpVelocity = -820;
  static const double playerSize = 48;

  double velocityY = 0;
  bool isOnGround = true;

  Player({required double groundY})
      : super(
          size: Vector2.all(playerSize),
          position: Vector2(80, groundY - playerSize),
          paint: Paint()..color = const Color(0xFF4FD1C5),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  void jump() {
    if (isOnGround) {
      velocityY = jumpVelocity;
      isOnGround = false;
      SoundService.instance.playJump();
      add(
        ScaleEffect.by(
          Vector2(0.85, 1.2),
          EffectController(duration: 0.08, alternate: true),
        ),
      );
    }
  }

  void reset(double groundY) {
    position = Vector2(80, groundY - playerSize);
    velocityY = 0;
    isOnGround = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!game.isGameOver) {
      velocityY += gravity * dt;
      position.y += velocityY * dt;

      final groundY = game.groundY - playerSize;
      if (position.y >= groundY) {
        final wasFalling = !isOnGround;
        position.y = groundY;
        velocityY = 0;
        isOnGround = true;
        if (wasFalling) {
          add(
            ScaleEffect.by(
              Vector2(1.2, 0.8),
              EffectController(duration: 0.08, alternate: true),
            ),
          );
        }
      }
    }
  }
}
