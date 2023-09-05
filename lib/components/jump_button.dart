import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class JumpButton extends SpriteComponent
    with HasGameRef<PixelAdventure>, TapCallbacks {
  JumpButton();
  @override
  FutureOr<void> onLoad() {
    priority = 10; //davanti a tutto
    sprite = Sprite(game.images.fromCache('HUD/JumpButton.png'));
    position = Vector2(game.size.x - 32 - 72, game.size.y - 32 - 64);
    scale = Vector2.all(1.25);
    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    sprite = Sprite(game.images.fromCache('HUD/JumpButton.png'));
    game.player.hasJumped = false;
    super.onTapUp(event);
  }

  @override
  void onTapDown(TapDownEvent event) {
    sprite = Sprite(game.images.fromCache('HUD/JumpButtonHighlighted.png'));
    game.player.hasJumped = true;
    super.onTapDown(event);
  }
}
