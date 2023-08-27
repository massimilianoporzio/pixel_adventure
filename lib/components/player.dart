import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gamepads/gamepads.dart';
import 'package:pixel_adventure/constants/game_constants.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum PlayerState {
  idle,
  running,
}

//enum PlayerDirection { left, right, none }

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

  bool isMobile = defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.fuchsia ||
      defaultTargetPlatform == TargetPlatform.iOS;

  //in che dirzione va il player
  //PlayerDirection playerDirection = PlayerDirection.none;
  //verso dove guarda
  bool isFacingRight = true;
  double horizontalInput = 0; //da tastiera o gamepad/joystick
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() async {
    if (!isMobile) {
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
              horizontalInput = -1;
            } else if (isRight) {
              horizontalInput = 1;
            } else {
              horizontalInput = 0;
            }
          }
        });
      }
    }

    _loadAllAnimations();
    return super.onLoad();
  }

  //chiamata ad OGNI frame
  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalInput = 0; //default poi controllo
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    horizontalInput += isLeftKeyPressed ? -1 : 0;
    horizontalInput += isRightKeyPressed ? 1 : 0;
    //se le premo entrambe add e tolgo 1
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

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle; //fermo e poi controllo
    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter(); //scale mi dice se guardo a dx o sin
    }
    if (velocity.x > 0 || velocity.x < 0) {
      //si muove!
      playerState = PlayerState.running;
    } else {
      playerState = PlayerState.idle;
    }
    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalInput * moveSpeed;
    position.x += velocity.x * dt; //vel lungo x
  }
}
