import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:logging/logging.dart';
import 'package:runnur/actors/player.dart';

/// [Character] enum class for the characters in the game.
enum Character {
  /// [maskDude] The mask dude character.
  maskDude,

  /// [ninjaFrog] The ninja frog character.
  ninjaFrog,

  /// [pinkMan] The pink man character.
  pinkMan,

  /// [virtualGuy] The virtual guy character.
  virtualGuy,
}

/// [CharacterExtension] extension class for the [Character] enum class.
extension CharacterExtension on Character {
  /// [name] The name of the character.
  String get name {
    switch (this) {
      case Character.ninjaFrog:
        return 'Ninja Frog';
      case Character.pinkMan:
        return 'Pink Man';
      case Character.virtualGuy:
        return 'Virtual Guy';
      case Character.maskDude:
        return 'Mask Dude';
    }
  }
}

/// [Levels] class for the levels in the game.
class Levels extends World {
  /// [Levels] constructor.
  Levels({required this.levelName});

  /// [levelName] The name of the level.
  String levelName;

  /// [level] The [TiledComponent] for the level.
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);

    final spawnPointsPlayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoint');

    if (spawnPointsPlayer != null) {
      for (final spawnPoint in spawnPointsPlayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            add(
              Player(
                character: Character.maskDude.name,
                position: Vector2(spawnPoint.x, spawnPoint.y),
              ),
            );
        }
      }
    } else {
      Logger('levels.dart').warning('No spawn points found in the level.');
    }

    return super.onLoad();
  }
}
