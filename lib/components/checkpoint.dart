import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/constants/game_constants.dart';

import 'player.dart';

class CheckPoint extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  CheckPoint({super.position, super.size});
  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      _reachedCheckpoint();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(
      collisionType: CollisionType.passive,
      position: Vector2(18, 56), //offset rispetto al Quadratone
      size: Vector2(12, 8), //dim del retangolino in basso per la collisione
    )
      ..debugColor = Colors.black
      ..debugMode = false);
    animation = SpriteAnimation.fromFrameData(
      game.images
          .fromCache('Items/Checkpoints/Checkpoint/$kCheckPointNoFlagName'),
      SpriteAnimationData.sequenced(
        amount: checkpointProps['noFlag']['amountOfSprites'],
        stepTime: checkpointProps['noFlag']['stepTime'],
        textureSize: Vector2.all(checkpointProps['noFlag']['textureSize']),
      ),
    );
    return super.onLoad();
  }

  Future<void> _reachedCheckpoint() async {
    //change animation
    animation = SpriteAnimation.fromFrameData(
      game.images
          .fromCache('Items/Checkpoints/Checkpoint/$kCheckPointFlagOutName'),
      SpriteAnimationData.sequenced(
        loop: false,
        amount: checkpointProps['flagOut']['amountOfSprites'],
        stepTime: checkpointProps['flagOut']['stepTime'],
        textureSize: Vector2.all(checkpointProps['flagOut']['textureSize']),
      ),
    );
    await animationTicker?.completed;

    animation = SpriteAnimation.fromFrameData(
      game.images
          .fromCache('Items/Checkpoints/Checkpoint/$kCheckPointFlagIdleName'),
      SpriteAnimationData.sequenced(
        amount: checkpointProps['flagIdle']['amountOfSprites'],
        stepTime: checkpointProps['flagIdle']['stepTime'],
        textureSize: Vector2.all(checkpointProps['flagIdle']['textureSize']),
      ),
    );
  }
}
