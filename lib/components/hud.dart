import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Hud extends Component with HasGameRef<PixelAdventure> {
  int score = 0;
  Hud({super.children, super.priority});

  @override
  FutureOr<void> onLoad() {
    final scoreTextComponent = TextComponent(
        text: 'Score: ${game.playerData.score.value}',
        position: Vector2(36, 12));
    add(scoreTextComponent);
    game.playerData.score.addListener(() {
      scoreTextComponent.text = 'Score: ${game.playerData.score.value}';
    });

    final healthTextComponent = TextComponent(
        text: 'x${game.playerData.health.value}',
        anchor: Anchor.topRight,
        position: Vector2(gameRef.size.x - 100, 12));
    game.playerData.health.addListener(() {
      healthTextComponent.text = 'x${game.playerData.health.value}';
    });
    add(healthTextComponent);
    final playerSprite = game.player.idleAnimation.frames[0].sprite;
    final playerSpriteComponent = SpriteComponent(
        sprite: playerSprite,
        anchor: Anchor.topCenter,
        position: Vector2(healthTextComponent.position.x - 54, 8),
        size: Vector2.all(32));
    add(playerSpriteComponent);
    return super.onLoad();
  }
}
