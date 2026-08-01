import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'salto_game.dart';

class Obstacle extends RectangleComponent
    with CollisionCallbacks, HasGameReference<SaltoGame> {
  Obstacle({required Vector2 position, required Vector2 size})
      : super(
          position: position,
          size: size,
          paint: Paint()..color = const Color(0xFFF56565),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isGameOver) return;

    position.x -= game.currentSpeed * dt;
    if (position.x + size.x < 0) {
      removeFromParent();
    }
  }
}
