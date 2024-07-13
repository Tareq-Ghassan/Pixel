/// [CustomHitBox] class that define collision the actuel hitbox for any object
class CustomHitBox {
  /// [CustomHitBox] Constructor
  CustomHitBox({
    required this.offsetX,
    required this.offsetY,
    required this.width,
    required this.height,
  });

  /// [offsetX] holds the actual strat of the player
  final double offsetX;

  /// [offsetY] holds the actual end of the player
  final double offsetY;

  ///  [width] the width of the player
  final double width;

  /// [height] the height of the player
  final double height;
}
