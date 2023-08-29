import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/constants/game_constants.dart';

class BackgroundTile extends ParallaxComponent {
  final String color;
  BackgroundTile({super.position, this.color = 'Gray'});

  final double scrollSpeed = kScrollSpeed;

  @override
  Future<void> onLoad() async {
    priority = -10; //STA DIETRO!
    size = Vector2.all(kBackgroundTileSize);
    parallax = await gameRef.loadParallax(
      [ParallaxImageData('Background/$color.png')],
      baseVelocity: Vector2(0, -scrollSpeed),
      repeat: ImageRepeat.repeat,
      fill: LayerFill.none,
    );
    return super.onLoad();
  }
}
