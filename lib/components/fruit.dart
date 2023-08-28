import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/constants/game_constants.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

import 'custom_hitbox.dart';

class Fruit extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final String fruitName;
  //suo hitbox
  late CustomHitBox hitbox;

  Fruit({
    super.position,
    super.size,
    this.fruitName = 'Apple',
  });
  bool _collected = false;
  final double stepTime = kFruitStepTime;

  void _buildHitBox({required String fruitName}) {
    hitbox = CustomHitBox(
      offsetX: fruitProps[fruitName]['hitbox']['offsetX'],
      offsetY: fruitProps[fruitName]['hitbox']['offsetY'],
      width: fruitProps[fruitName]['hitbox']['width'],
      height: fruitProps[fruitName]['hitbox']['height'],
    );
  }

  @override
  FutureOr<void> onLoad() {
    _buildHitBox(fruitName: fruitName);
    add(RectangleHitbox(
      collisionType:
          CollisionType.passive, //solo se un active gli sbatte contro
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    )
      ..debugColor = const Color.fromARGB(255, 64, 200, 0)
      ..debugMode = false);

    priority = -1; //stessa del background
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/$fruitName.png'),
      SpriteAnimationData.sequenced(
        amount: fruitProps[fruitName]['amountOfSprites'],
        stepTime: fruitProps[fruitName]['stepTime'],
        textureSize: Vector2.all(fruitProps[fruitName]['textureSize']),
      ),
    );
    return super.onLoad();
  }

  //metodo chiamato quando player collide con fruit
  void collidedWithPlayer() async {
    if (!_collected) {
      //ANIMAZIONE
      animation = SpriteAnimation.fromFrameData(
          game.images.fromCache("Items/Fruits/$kCollectedName.png"),
          SpriteAnimationData.sequenced(
            amount: fruitProps[kCollectedName]['amountOfSprites'],
            stepTime: fruitProps[kCollectedName]['stepTime'],
            loop: false,
            textureSize: Vector2.all(
              fruitProps[kCollectedName]['textureSize'],
            ),
          ));
      _collected = true;
      //mezzo secondo e poi rimuovo
      await Future.delayed(const Duration(milliseconds: 500));
      removeFromParent();
    }
  }
}
