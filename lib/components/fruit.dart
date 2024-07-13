import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:runnur/components/custom_hitbox.dart';
import 'package:runnur/pixel.dart';

/// [Fruit] class created to define fruits in app
class Fruit extends SpriteAnimationComponent
    with HasGameRef<Pixel>, CollisionCallbacks {
  /// [Fruit] Construtor
  Fruit({
    this.fruit = 'Apple',
    super.position,
    super.size,
    super.removeOnFinish = true,
  });

  /// [fruit] variable to define fruits
  String fruit;

  /// [stepTime] is the time of the animation per frame
  final double stepTime = 0.05;

  /// [hitbox] holds the hitbox axes for fruits
  final hitbox = CustomHitBox(
    offsetX: 10,
    offsetY: 10,
    width: 12,
    height: 12,
  );
  bool _collected = false;

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    priority = -1;
    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/$fruit.png'),
      SpriteAnimationData.sequenced(
        amount: 17,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
    return super.onLoad();
  }

  /// [collidedWithPlayer] funtion handle collision between fruits and player
  void collidedWithPlayer() {
    if (!_collected) {
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/Collected.png'),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
          loop: false,
        ),
      );
      game.score++;
      _collected = true;
    }
  }
}
