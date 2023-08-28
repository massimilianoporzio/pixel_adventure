import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/constants/game_constants.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class BackgroundTile extends SpriteComponent with HasGameRef<PixelAdventure> {
  final String color;
  BackgroundTile({super.position, this.color = 'Gray'});

  final double scrollSpeed = kScrollSpeed;

  @override
  FutureOr<void> onLoad() {
    priority = -1; //STA DIETRO!
    size = Vector2.all(kBackgroundTileSize + 0.7);
    sprite = Sprite(game.images.fromCache('Background/$color.png'));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y += scrollSpeed;
    double tileSize = kBackgroundTileSize;
    int scrollHeight = (game.size.t / tileSize).floor();
    if (position.y > scrollHeight * tileSize) {
      position.y = -tileSize; //riporto su un po' prima (una size prima)
    }
    super.update(dt);
  }
}
