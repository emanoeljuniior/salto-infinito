import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

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
        position.y = groundY;
        velocityY = 0;
        isOnGround = true;
      }
    }
  }
}
