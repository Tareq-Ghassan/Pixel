import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:runnur/pixel.dart';

void main() async {
  //Add to review
  if (kReleaseMode) {
    Logger.root.level = Level.WARNING;
  }
  Logger.root.onRecord.listen((record) {
    debugPrint(
      '${record.level.name}: ${record.time}: '
      '${record.loggerName}: '
      '${record.message}',
    );
  });
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  final game = Pixel();
  runApp(GameWidget(game: kDebugMode ? Pixel() : game));
}
