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
        position: Vector2(64, 48));
    add(scoreTextComponent);
    game.playerData.score.addListener(() {
      scoreTextComponent.text = 'Score: ${game.playerData.score.value}';
    });
    return super.onLoad();
  }
}
