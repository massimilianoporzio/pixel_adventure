import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/constants/game_constants.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Saw extends SpriteAnimationComponent with HasGameRef<PixelAdventure> {
  final bool isVertical;
  final double offsetNeg;
  final double offsetPos;
  Saw({
    super.position,
    super.size,
    this.isVertical = false,
    this.offsetNeg = 0,
    this.offsetPos = 0,
  });

  //per il movimento
  double moveDirection = 1; //+1: verso destra ( o basso)
  double rangeNeg = 0;
  double rangePos = 0; //moltiplico offset * dim tiles e ottengo il range

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    add(CircleHitbox()
      ..debugColor = Colors.grey.shade700
      ..debugMode = false);
    rangeNeg =
        (isVertical ? position.y : position.x) - offsetNeg * kMapTileSize;
    rangePos =
        (isVertical ? position.y : position.x) + offsetPos * kMapTileSize;

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Saw/$kSawOnImage'),
      SpriteAnimationData.sequenced(
        amount: sawProps[kSawName]['amountOfSprites'],
        stepTime: sawProps[kSawName]['stepTime'],
        textureSize: Vector2.all(sawProps[kSawName]['textureSize']),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isVertical) {
      _moveVertically(dt);
    } else {
      _moveHorizontally(dt);
    }
    super.update(dt);
  }

  void _moveVertically(double dt) {
    if (position.y >= rangePos) {
      moveDirection = -1;
    } else if (position.y <= rangeNeg) {
      moveDirection = 1;
    }
    position.y += moveDirection * kSawMoveSpeed * dt;
  }

  void _moveHorizontally(double dt) {
    if (position.x >= rangePos) {
      moveDirection = -1;
    } else if (position.x <= rangeNeg) {
      moveDirection = 1;
    }
    position.x += moveDirection * kSawMoveSpeed * dt;
  }
}
