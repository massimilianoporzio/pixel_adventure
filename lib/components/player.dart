import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gamepads/gamepads.dart';
import 'package:pixel_adventure/components/custom_hitbox.dart';
import 'package:pixel_adventure/components/fruit.dart';
import 'package:pixel_adventure/components/saw.dart';
import 'package:pixel_adventure/constants/game_constants.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/utils/utils.dart';

import 'collision_block.dart';

enum PlayerState {
  idle,
  running,
  jumping,
  falling,
  hit,
}

//enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler, CollisionCallbacks {
  final String character;
  Player({
    position,
    required this.character,
  }) : super(position: position);

  //gruppi di animazioni non solo una!
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;

  //suo hitbox
  late CustomHitBox hitbox;

  //posiz iniziale
  Vector2 startingPosition = Vector2.zero();

  //proprietà
  final double _gravity = 9.8;
  final double _jumpForce = 360;
  final double _terminalVelocity = 300; //max vel di caduta
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();

  bool isMobile = defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.fuchsia ||
      defaultTargetPlatform == TargetPlatform.iOS;

  //in che dirzione va il player
  //PlayerDirection playerDirection = PlayerDirection.none;
  //verso dove guarda
  bool isFacingRight = true;
  bool isOnGround = false; //se poggia per terra
  bool hasJumped = false; //se ha fatto un salto
  bool gotHit = false;

  //input da utente
  double horizontalInput = 0; //da tastiera o gamepad/joystick

  //anche il player ha un rif alla lista di blocchi di collisione
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    startingPosition = Vector2(position.x, position.y);
    if (!isMobile) {
      _setUpGamePad();
    }
    _buildHitBox(character: character);
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    )
      ..debugColor = const Color.fromARGB(255, 255, 128, 0)
      ..debugMode = false);
    _loadAllAnimations();
    return super.onLoad();
  }

  void _buildHitBox({required String character}) {
    hitbox = CustomHitBox(
      offsetX: characterProps[character]['hitbox']['offsetX'],
      offsetY: characterProps[character]['hitbox']['offsetY'],
      width: characterProps[character]['hitbox']['width'],
      height: characterProps[character]['hitbox']['height'],
    );
  }

  void _setUpGamePad() async {
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
        if (event.type == KeyType.button) {
          hasJumped = event.value == 1.0;
        }
      });
    }
  }

  //chiamata ad OGNI frame
  @override
  void update(double dt) {
    if (!gotHit) {
      _updatePlayerState();
      _updatePlayerMovement(dt);
      _checkHorizontalCollisions();
      //gravity DOPO!
      _applyGravity(dt);
      //ora controllo in verticale
      _checkVerticalCollisions();
    }

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
    //gestisco il salto
    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    //WHEN My rectangle hit box collide with other rectangle hit box
    if (other is Fruit) {
      other.collidedWithPlayer();
    } else if (other is Saw) {
      //AHIA!
      _respawn();
    }
    super.onCollision(intersectionPoints, other);
  }

  void _loadAllAnimations() {
    idleAnimation = _getSpriteAnimation(
        characterName: character,
        state: 'Idle',
        amountOfSprites: characterProps[character]['animations']['idle']
            ['amountOfSprites'],
        stepTime: characterProps[character]['animations']['idle']['stepTime'],
        tileSize: characterProps[character]['tileSize']);
    runningAnimation = _getSpriteAnimation(
        characterName: character,
        state: 'Run',
        amountOfSprites: characterProps[character]['animations']['running']
            ['amountOfSprites'],
        stepTime: characterProps[character]['animations']['running']
            ['stepTime'],
        tileSize: characterProps[character]['tileSize']);
    jumpingAnimation = _getSpriteAnimation(
        characterName: character,
        state: 'Jump',
        amountOfSprites: characterProps[character]['animations']['jumping']
            ['amountOfSprites'],
        stepTime: characterProps[character]['animations']['jumping']
            ['stepTime'],
        tileSize: characterProps[character]['tileSize']);
    fallingAnimation = _getSpriteAnimation(
        characterName: character,
        state: 'Fall',
        amountOfSprites: characterProps[character]['animations']['falling']
            ['amountOfSprites'],
        stepTime: characterProps[character]['animations']['falling']
            ['stepTime'],
        tileSize: characterProps[character]['tileSize']);
    hitAnimation = _getSpriteAnimation(
        characterName: character,
        state: 'Hit',
        amountOfSprites: characterProps[character]['animations']['hit']
            ['amountOfSprites'],
        loop: false,
        stepTime: characterProps[character]['animations']['hit']['stepTime'],
        tileSize: characterProps[character]['tileSize']);

    //lista delle animazioni disponib per ogni stato
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.hit: hitAnimation,
    };
    //animazione corrente (la setto!)
    current = PlayerState.idle;
  }

  SpriteAnimation _getSpriteAnimation({
    required String characterName,
    required String state,
    required int amountOfSprites,
    required double stepTime,
    required double tileSize,
    bool loop = true,
  }) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'Main Characters/$characterName/$state (${tileSize.toInt()}x${tileSize.toInt()}).png'),
      SpriteAnimationData.sequenced(
        amount: amountOfSprites,
        stepTime: stepTime,
        loop: loop,
        textureSize: Vector2.all(tileSize),
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
    //check if falling
    if (velocity.y > 0) {
      playerState = PlayerState.falling;
    }
    //check if jumping
    if (velocity.y < 0) {
      playerState = PlayerState.jumping;
    }
    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) {
      _playerJump(dt);
    }
    //SERVE PER SALTARE ANCHE SE NON HO TOCCATO IL GROUND (OPZIONALE)
    if (velocity.y > _gravity) {
      isOnGround = true;
    }
    velocity.x = horizontalInput * moveSpeed;
    position.x += velocity.x * dt; //vel lungo x
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false; //non salta +
    hasJumped = false;
  }

  void _checkHorizontalCollisions() {
    //loop over collision block
    for (final block in collisionBlocks) {
      //handle collisions
      //for platform non mi interessano le collisioni orizzontali
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          //*HERE COLLISION tengo conto del hitbox
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break; //non guardo gli altri blocchi
          }
          if (velocity.x < 0) {
            //sto andando a sinistra
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.offsetX + hitbox.width;
            break; //non guardo gli altri blocchi
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity; //ogni dt aum costante
    velocity.y = velocity.y.clamp(-_jumpForce,
        _terminalVelocity); //mai + veloce del salto e + di terminalVel
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        //handle platform ci salgo da sotto ma poi ci resto sopra
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            //sto cadendo
            velocity.y = 0; // ma poi aumenta con gravità
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break; //basta una collisione poi non guardo le restanti
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            //sto cadendo
            velocity.y = 0; // ma poi aumenta con gravità
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break; //basta una collisione poi non guardo le restanti
          }
          if (velocity.y < 0) {
            //JUMP
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }

  void _respawn() {
    const hitDuration = Duration(milliseconds: 350);
    gotHit = true; //cosi non fa più update

    //ANIMAZIONE E POI RIMETTO ALL'INIZIO
    current = PlayerState.hit;
    Future.delayed(hitDuration, () {
      scale.x = 1.0;
      position = startingPosition;
      gotHit = false;
    });
    //position = startingPosition;
  }
}
