import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:runnur/components/levels.dart';
import 'package:runnur/components/player.dart';

/// [LevelMap] this is the enum for the levels
enum LevelMap {
  /// [levelOne] this is the first level
  levelOne,

  /// [levelTwo] this is the second level
  levelTwo,

  /// [levelThree] this is the third level
  levelThree,
}

/// [name] this is the extension for the enum
extension LevelsMap on LevelMap {
  /// [name] this is the name of the level file
  String get name {
    switch (this) {
      case LevelMap.levelOne:
        return 'Level-01';
      case LevelMap.levelTwo:
        return 'Level-02';
      case LevelMap.levelThree:
        return 'Level-03';
    }
  }
}

/// [Pixel] this is the Main App class
class Pixel extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  /// [player] this is the player class
  Player player = Player(character: Character.pinkMan.name);

  /// [joystick] this is the joystick class
  late JoystickComponent joystick;

  /// [showJoystick] this is to show the joystick on screen
  bool showJoystick = true;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    @override
    final world = Levels(levelName: LevelMap.levelOne.name, player: player);

    camera = CameraComponent.withFixedResolution(
      width: 640,
      height: 360,
      world: world,
    );

    camera.viewfinder.anchor = Anchor.topLeft;

    await addAll([camera, world]);
    if (showJoystick) {
      addJoystick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  /// [addJoystick] this is the function to add the joystick on screen
  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystick);
  }

  /// [updateJoystick] this is the function to update the joystick on screen
  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.down || JoystickDirection.idle:
        player.horizontalMovement = 0;
      case JoystickDirection.left ||
            JoystickDirection.upLeft ||
            JoystickDirection.downLeft:
        player.horizontalMovement = -1;
      case JoystickDirection.right ||
            JoystickDirection.upRight ||
            JoystickDirection.downRight:
        player.horizontalMovement = 1;
      case JoystickDirection.up:
        player.hasjumped = true;
    }
  }
}
