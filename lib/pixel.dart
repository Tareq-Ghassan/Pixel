import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:runnur/levels/levels.dart';

class Pixel extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  final world = Levels();

  @override
  FutureOr<void> onLoad() {
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
