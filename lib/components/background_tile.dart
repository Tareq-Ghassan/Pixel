import 'dart:async';

import 'package:flame/components.dart';
import 'package:runnur/pixel.dart';

/// [BackgroundTile] class created for adding background for the game
class BackgroundTile extends SpriteComponent with HasGameRef<Pixel> {
  /// [BackgroundTile] constructor
  BackgroundTile({this.color = 'Gray', super.position});

  /// [color] holds backgroind color
  String color;

  /// [scrollSpeed] holds the speed of scrolling the background
  double scrollSpeed = 0.4;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    size = Vector2.all(64.6);
    sprite = Sprite(game.images.fromCache('Background/$color.png'));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y += scrollSpeed;
    const tileSize = 64.6;
    final scrollHight = (game.size.y / tileSize).floor();
    if (position.y > scrollHight * tileSize) {
      position.y = -tileSize;
    }
    super.update(dt);
  }
}
