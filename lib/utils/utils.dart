import '../components/collision_block.dart';
import '../components/player.dart';

bool checkCollision(Player player, CollisionBlock block) {
  final hitBox = player.hitbox; //uso per fare collision sul player
  final playerX = player.position.x + hitBox.offsetX;
  final playerY = player.position.y + hitBox.offsetY;
  final playerWidth = hitBox.width;
  final playerHeight = hitBox.height;

  final blockX = block.position.x;
  final blockY = block.position.y;
  final blockWidth = block.width;
  final blockHeigth = block.height;
  //quando vado a sinistra l'anchor è ribaltato orizzontalmente...
  final fixedX = player.scale.x < 0
      ? playerX - (hitBox.offsetX * 2) - playerWidth
      : playerX;
  final fixedY = block.isPlatform
      ? playerY + playerHeight
      : playerY; //per le platform check the bottom of the player

  //handle custom collision on rectangles
  return (fixedY < blockY + blockHeigth &&
      playerY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}
