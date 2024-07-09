import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:runnur/pixel.dart';

/// [PlayerState] holde the state of the player
enum PlayerState {
  /// [idle] The player is idle
  idle,

  /// [running] The player is running
  running,
}

/// [PlayerStateExtension] is the extension of the [PlayerState]
extension PlayerStateExtension on PlayerState {
  /// [name] is the name of the [PlayerState] as a string
  String get name {
    switch (this) {
      case PlayerState.idle:
        return 'Idle';
      case PlayerState.running:
        return 'Run';
    }
  }
}

/// [PlayerDirection] is the direction of the player
enum PlayerDirection {
  /// [left] The player is moving left
  left,

  /// [right] The player is moving right
  right,

  /// [none] The player is not moving
  none,
}

/// [Player] is the player of the game
class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<Pixel>, KeyboardHandler {
  /// [Player] constructors
  Player({this.character = 'Ninja Frog', super.position});

  /// [character] is the character of the player
  String character;

  /// [idle] is the idle animation of the player
  late final SpriteAnimation idle;
  //// [runing] is the runing animation of the player
  late final SpriteAnimation runing;

  /// [stepTime] is the time of the animation per frame
  final double stepTime = 0.05;

  /// [playerDirection] is the direction of the player
  PlayerDirection playerDirection = PlayerDirection.none;

  /// [moveSpeed] is the speed of the player
  double moveSpeed = 100;

  /// [velocity] is the velocity of the player
  Vector2 velocity = Vector2.zero();

  /// [isFacingRight] is the direction of the player
  bool isFacingRight = true;

  @override
  FutureOr<void> onLoad() {
    _loadAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed = keysPressed.contains(
          LogicalKeyboardKey.arrowLeft,
        ) ||
        keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRightKeyPressed = keysPressed.contains(
          LogicalKeyboardKey.arrowRight,
        ) ||
        keysPressed.contains(LogicalKeyboardKey.keyD);

    if (isLeftKeyPressed && isRightKeyPressed) {
      playerDirection = PlayerDirection.none;
    } else if (isLeftKeyPressed) {
      playerDirection = PlayerDirection.left;
    } else if (isRightKeyPressed) {
      playerDirection = PlayerDirection.right;
    } else {
      playerDirection = PlayerDirection.none;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAnimations() {
    idle = _createSpriteAnimation(
      state: PlayerState.idle.name,
      amount: 11,
    );

    runing = _createSpriteAnimation(
      state: PlayerState.running.name,
      amount: 12,
    );

    animations = {
      PlayerState.idle: idle,
      PlayerState.running: runing,
    };
    current = PlayerState.idle;
  }

  SpriteAnimation _createSpriteAnimation({
    required String state,
    required int amount,
  }) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void _updateMovement(double dt) {
    var dx = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.running;
        dx -= moveSpeed;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.running;
        dx += moveSpeed;
      case PlayerDirection.none:
        current = PlayerState.idle;
        dx = 0;
    }
    velocity = Vector2(dx, 0);
    position += velocity * dt;
  }
}
