import 'package:pixel_adventure/components/collision_block.dart';

import '../components/player.dart';

bool checkCollision(Player player, CollisionBlock block) {
  final playerX = player.position.x;
  final playerY = player.position.y;
  final playerWidth = player.width;
  final playerHeight = player.height;

  final blockX = block.position.x;
  final blockY = block.position.y;
  final blockWidth = block.width;
  final blockHeigth = block.height;
  //quando vado a sinistra l'anchor è ribaltato orizzontalmente...
  final fixedX = player.scale.x < 0 ? playerX - playerWidth : playerX;

  //handle custom collision on rectangles
  return (playerY < blockY + blockHeigth &&
      playerY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}
