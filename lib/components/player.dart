import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:runnur/components/collision_block.dart';
import 'package:runnur/components/player_hitbox.dart';
import 'package:runnur/components/utils.dart';
import 'package:runnur/pixel.dart';

/// [PlayerState] holde the state of the player
enum PlayerState {
  /// [idle] The player is idle
  idle,

  /// [running] The player is running
  running,

  /// [faling] The player is faling
  faling,

  /// [jumping] The player is jumping
  jumping,
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
      case PlayerState.faling:
        return 'Fall';
      case PlayerState.jumping:
        return 'Jump';
    }
  }
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

  //// [jumping] is the jumping animation of the player
  late final SpriteAnimation jumping;

  //// [faling] is the faling animation of the player
  late final SpriteAnimation faling;

  /// [stepTime] is the time of the animation per frame
  final double stepTime = 0.05;

  /// [horizontalMovement] holds the  horizontal Movement
  double horizontalMovement = 0;

  /// [moveSpeed] is the speed of the player
  double moveSpeed = 100;

  /// [velocity] is the velocity of the player
  Vector2 velocity = Vector2.zero();

  /// [collisionBlocks] holds collision objects
  List<CollisionBlock> collisionBlocks = [];

  /// [isOnGround] holds if the user
  bool isOnGround = false;

  /// [hasjumped] if user jumped
  bool hasjumped = false;

  /// [hitbox] the actual axes for player collision box
  PlayerHitbox hitbox = PlayerHitbox(
    height: 28,
    width: 14,
    offsetX: 10,
    offsetY: 4,
  );

  final double _gravity = 9.8;
  final double _jumpForce = 300;
  final double _terminalVelocity = 300;

  @override
  FutureOr<void> onLoad() {
    _loadAnimations();
    // debugMode = true;
    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updateMovement(dt);
    _checkHorizontalCollision();
    _applyGravity(dt);
    _checkVerticalCollision();
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(
          LogicalKeyboardKey.arrowLeft,
        ) ||
        keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRightKeyPressed = keysPressed.contains(
          LogicalKeyboardKey.arrowRight,
        ) ||
        keysPressed.contains(LogicalKeyboardKey.keyD);
    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasjumped = keysPressed.contains(LogicalKeyboardKey.space) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);

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

    jumping = _createSpriteAnimation(
      state: PlayerState.jumping.name,
      amount: 1,
    );

    faling = _createSpriteAnimation(
      state: PlayerState.faling.name,
      amount: 1,
    );

    animations = {
      PlayerState.idle: idle,
      PlayerState.running: runing,
      PlayerState.faling: faling,
      PlayerState.jumping: jumping,
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

  void _updatePlayerState() {
    var playerState = PlayerState.idle;
    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }
    if (velocity.x > 0 || velocity.x < 0) {
      playerState = PlayerState.running;
    }
    if (velocity.y > 0) {
      playerState = PlayerState.faling;
    }
    if (velocity.y < 0) {
      playerState = PlayerState.jumping;
    }

    current = playerState;
  }

  void _updateMovement(double dt) {
    if (hasjumped && isOnGround) {
      _playerJump(dt);
    }
    // if (velocity.y > _gravity) isOnGround = false;
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _checkHorizontalCollision() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(player: this, collisionBlock: block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          } else if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity
      ..y += _gravity
      ..y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollision() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(player: this, collisionBlock: block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      } else {
        if (checkCollision(player: this, collisionBlock: block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      }
    }
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasjumped = false;
  }
}
