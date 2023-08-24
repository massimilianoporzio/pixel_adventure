import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/constants/game_constants.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

enum PlayerState {
  idle,
  running,
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure> {
  final String character;
  Player({required this.character}) : super();

  //gruppi di animazioni non solo una!
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  void _loadAllAnimations() {
    idleAnimation = _getSpriteAnimation(
        characterName: character,
        state: 'Idle',
        amountOfSprites: kIdleNinjaFrogSprites,
        stepTime: kNinjaFrogIdleStepTime,
        textureSize: Vector2.all(kNinjaFrogTileSize));

    runningAnimation = _getSpriteAnimation(
        state: 'Run',
        characterName: character,
        amountOfSprites: kRunningNinjaFrogSprites,
        stepTime: kNinjaFrogRunningStepTime,
        textureSize: Vector2.all(kNinjaFrogTileSize));
    //lista delle animazioni disponib per ogni stato
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation
    };
    //animazione corrente (la setto!)
    current = PlayerState.running;
  }

  SpriteAnimation _getSpriteAnimation({
    required String characterName,
    required String state,
    required int amountOfSprites,
    required double stepTime,
    required Vector2 textureSize,
  }) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'Main Characters/$characterName/$state (${textureSize[0].toInt()}x${textureSize[1].toInt()}).png'),
      SpriteAnimationData.sequenced(
        amount: amountOfSprites,
        stepTime: stepTime,
        textureSize: textureSize,
      ),
    );
  }
}
