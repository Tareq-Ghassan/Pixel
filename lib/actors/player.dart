import 'dart:async';

import 'package:flame/components.dart';
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

/// [Player] is the player of the game
class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<Pixel> {
  /// [Player] constructors
  Player({required this.character, super.position});

  /// [character] is the character of the player
  String character;

  /// [idle] is the idle animation of the player
  late final SpriteAnimation idle;
  //// [runing] is the runing animation of the player
  late final SpriteAnimation runing;

  /// [stepTime] is the time of the animation per frame
  final double stepTime = 0.05;

  @override
  FutureOr<void> onLoad() {
    _loadAnimations();
    return super.onLoad();
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
}
