import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:logging/logging.dart';
import 'package:runnur/components/background_tile.dart';
import 'package:runnur/components/collision_block.dart';
import 'package:runnur/components/fruit.dart';
import 'package:runnur/components/player.dart';
import 'package:runnur/components/saw.dart';
import 'package:runnur/pixel.dart';

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
class Levels extends World with HasGameRef<Pixel> {
  /// [Levels] constructor.
  Levels({required this.levelName, required this.player});

  /// [levelName] The name of the level.
  String levelName;

  /// [player] The [Player] actor.
  final Player player;

  /// [level] The [TiledComponent] for the level.
  late TiledComponent level;

  /// [collisionBlocks] holds a list of all collision blocks in game
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);

    _scrollingBackground();

    _spawningObjects();

    _addCollisions();

    return super.onLoad();
  }

  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer('backgorund');
    const tileSize = 64;
    final numTilesY = (game.size.y / tileSize).floor();
    final numTilesX = (game.size.x / tileSize).floor();

    if (backgroundLayer != null) {
      final backgroundColor =
          backgroundLayer.properties.getValue<String>('BackgroundColor');
      for (var y = 0.0; y < game.size.y / numTilesY; y++) {
        for (var x = 0.0; x < numTilesX; x++) {
          final backgroundTile = BackgroundTile(
            color: backgroundColor ?? 'Gray',
            position: Vector2(x * tileSize, y * tileSize),
          );
          add(backgroundTile);
        }
      }
    } else {
      Logger('levels.dart').warning('No background found in the level.');
    }
  }

  void _spawningObjects() {
    final spawnPointsPlayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoint');

    if (spawnPointsPlayer != null) {
      for (final spawnPoint in spawnPointsPlayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
          case 'Fruit':
            final fruit = Fruit(
              fruit: spawnPoint.name,
              position: Vector2(
                spawnPoint.x,
                spawnPoint.y,
              ),
              size: Vector2(
                spawnPoint.width,
                spawnPoint.height,
              ),
            );
            add(fruit);
          case 'Saw':
            final saw = Saw(
              isVertical: spawnPoint.properties.getValue('isVertical') as bool,
              offNeg: spawnPoint.properties.getValue('offNeg') as double,
              offPos: spawnPoint.properties.getValue('offPos') as double,
              position: Vector2(
                spawnPoint.x,
                spawnPoint.y,
              ),
              size: Vector2(
                spawnPoint.width,
                spawnPoint.height,
              ),
            );
            add(saw);
        }
      }
    } else {
      Logger('levels.dart').warning('No spawn points found in the level.');
    }
  }

  void _addCollisions() {
    final collisionLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionLayer != null) {
      for (final collision in collisionLayer.objects) {
        switch (collision.class_) {
          case 'Plattform':
            final platform = CollisionBlock(
              position: Vector2(
                collision.x,
                collision.y,
              ),
              size: Vector2(
                collision.width,
                collision.height,
              ),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);

          default:
            final block = CollisionBlock(
              position: Vector2(
                collision.x,
                collision.y,
              ),
              size: Vector2(
                collision.width,
                collision.height,
              ),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    } else {
      Logger('levels.dart')
          .warning('Collsions objects not found in the level.');
    }

    player.collisionBlocks = collisionBlocks;
  }
}
