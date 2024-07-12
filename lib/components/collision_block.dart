import 'package:flame/components.dart';

/// [CollisionBlock] this class define collission objects
class CollisionBlock extends PositionComponent {
  /// [CollisionBlock] constructor
  CollisionBlock({
    required super.position,
    required super.size,
    this.isPlatform = false,
  }) {
    // debugMode = true;
  }

  /// [isPlatform] holds if the object is a platform or not
  bool isPlatform;
}
