import 'package:runnur/components/collision_block.dart';
import 'package:runnur/components/player.dart';

/// [checkCollision] a function that check if collision happend or not
bool checkCollision({
  required Player player,
  required CollisionBlock collisionBlock,
}) {
  final hitbox = player.hitbox;

  // Get the position and size of the player
  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

// Get the position and size of the size of collisionBlocks
  final collisionBlockX = collisionBlock.x;
  final collisionBlockY = collisionBlock.y;
  final collisionBlockWidth = collisionBlock.width;
  final collisionBlockHeight = collisionBlock.height;

// this to fix X aces when the user moving to left
  final fixedX = player.scale.x < 0
      ? playerX - (hitbox.offsetX * 2) - playerWidth
      : playerX;
// this to fix Y aces when the user jump to always take the bottom acess
  final fixedY = collisionBlock.isPlatform ? playerY + playerHeight : playerY;

  return fixedX + playerWidth > collisionBlockX &&
      fixedX < collisionBlockX + collisionBlockWidth &&
      playerY + playerHeight > collisionBlockY &&
      fixedY < collisionBlockY + collisionBlockHeight;
}
