import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:runnur/levels/levels.dart';

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
class Pixel extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  final world = Levels(levelName: LevelMap.levelOne.name);

  @override
  FutureOr<void> onLoad() {
    images.loadAllImages();
    camera = CameraComponent.withFixedResolution(
      width: 640,
      height: 360,
      world: world,
    );

    camera.viewfinder.anchor = Anchor.topLeft;

    addAll([camera, world]);
    return super.onLoad();
  }
}
