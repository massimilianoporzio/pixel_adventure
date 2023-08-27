import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:gamepads/gamepads.dart';
import 'package:pixel_adventure/constants/game_constants.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum PlayerState {
  idle,
  running,
}

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  final String character;
  Player({
    position,
    this.character = kNinjaFrogName,
  }) : super(position: position);

  //gruppi di animazioni non solo una!
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

  //in che dirzione va il player
  PlayerDirection playerDirection = PlayerDirection.none;
  //verso dove guarda
  bool isFacingRight = true;

  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() async {
    //gestisco il controller
    final gamepads = await Gamepads.list();
    if (gamepads.isNotEmpty) {
      Gamepads.events.listen((event) {
        if (event.type == KeyType.analog) {
          final isLeft = event.key == "dwXpos" &&
              event.value < 32767.0; //dip dal controller
          final isRight = event.key == "dwXpos" &&
              event.value > 32767.0; //dip dal controller
          if (isLeft) {
            playerDirection = PlayerDirection.left;
          } else if (isRight) {
            playerDirection = PlayerDirection.right;
          } else {
            playerDirection = PlayerDirection.none;
          }
        }
      });
    }
    _loadAllAnimations();
    return super.onLoad();
  }

  //chiamata ad OGNI frame
  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    if (isLeftKeyPressed && isRightKeyPressed) {
      playerDirection =
          PlayerDirection.none; //premo sia sin sia dx...sto fermo!
    } else if (isLeftKeyPressed) {
      playerDirection = PlayerDirection.left;
    } else if (isRightKeyPressed) {
      playerDirection = PlayerDirection.right;
    } else {
      playerDirection = PlayerDirection.none;
    }
    return super.onKeyEvent(event, keysPressed);
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
    current = PlayerState.idle;
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

  void _updatePlayerMovement(double dt) {
    double dirX = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.running;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.running;
        dirX += moveSpeed;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
      default:
    }
    velocity = Vector2(dirX, 0);
    position += velocity * dt;
  }
}
