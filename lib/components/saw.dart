import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:runnur/pixel.dart';

/// [Saw] class to create a Saw Object Trap
class Saw extends SpriteAnimationComponent with HasGameRef<Pixel> {
  /// [Saw] constructor
  Saw({
    this.isVertical = false,
    this.offNeg = 0.0,
    this.offPos = 0.0,
    super.position,
    super.size,
  });

  /// [isVertical] define which Dimation will the Saw move
  final bool isVertical;

  /// [offNeg] how much sequres the saw will move negative
  ///
  /// if `isVertical` is `true` then negative is `up`
  ///
  /// if `isVertical` is `false` then negative is `left`
  final double offNeg;

  /// [offPos] how much sequres the saw will move postive
  ///
  /// if `isVertical` is `true` then postive is `down`
  ///
  /// if `isVertical` is `false` then postive is `right`
  final double offPos;

  /// [sawSpeed] is the time of the animation per frame
  static const double sawSpeed = 0.03;

  /// [moveSpeed] represent moving speed of the saw
  static const double moveSpeed = 100;

  /// [tileSize] represent the saw size
  static const double tileSize = 16;

  /// [moveDirection] represent the direction
  double moveDirection = 1;

  /// range how far can we go negative
  double rangeNeg = 0;

  /// range how far can we go postive
  double rangePos = 0;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    add(CircleHitbox());
    // debugMode = true;
    _fillRange();
    _addAnimation();
  }

  @override
  void update(double dt) {
    if (isVertical) {
      _moveVertically(dt);
    } else {
      _moveHorizontally(dt);
    }
    super.update(dt);
  }

  void _addAnimation() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Saw/On (38x38).png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: sawSpeed,
        textureSize: Vector2.all(38),
      ),
    );
  }

  void _fillRange() {
    if (isVertical) {
      rangeNeg = position.y - offNeg * tileSize;
      rangePos = position.y + offPos * tileSize;
    } else {
      rangeNeg = position.x - offNeg * tileSize;
      rangePos = position.x + offPos * tileSize;
    }
  }

  void _moveHorizontally(double dt) {
    if (position.x >= rangePos) {
      moveDirection = -1;
    } else if (position.x <= rangeNeg) {
      moveDirection = 1;
    }
    position.x += moveDirection * moveSpeed * dt;
  }

  void _moveVertically(double dt) {
    if (position.y >= rangePos) {
      moveDirection = -1;
    } else if (position.y <= rangeNeg) {
      moveDirection = 1;
    }
    position.y += moveDirection * moveSpeed * dt;
  }
}
