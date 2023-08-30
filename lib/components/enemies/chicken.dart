import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/constants/game_constants.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum ChickenState { idle, run, hit }

class Chicken extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Chicken({super.position, super.size, this.offsetNeg = 0, this.offsetPos = 0});
  //multiple animations

  late SpriteAnimation _idleAnimation;
  late SpriteAnimation _runAnimation;
  late SpriteAnimation _hitAnimation;

  final double offsetNeg;
  final double offsetPos;

  double rangeNeg = 0; //range in tiles a sin
  double rangePos = 0; //range in tiles a dx

  double moveDirection = 1; //pos verso dx
  double targetDirection = -1; //default il pollo guarda a sinistra

  bool gotStomped = false; //player mi ha schiacciato!

  Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    debugColor = Colors.purple;
    debugMode = false;
    add(RectangleHitbox(
        position: Vector2(4, 6), //TODO make props not hard-coded here
        size: Vector2(24, 26))
      ..debugColor = Colors.purple
      ..debugMode = false);
    _loadAllAnimations();
    _calculateRange();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!gotStomped) {
      //solo se non schiacciato
      _updateState();
      //SU E GIU
      _movement(dt);
    }

    super.update(dt);
  }

  SpriteAnimation _getSpriteAnimation({
    required String enemiesName,
    required String state,
    required int amountOfSprites,
    required double stepTime,
    required Vector2 tileSize,
    bool loop = true,
  }) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'Enemies/$enemiesName/$state (${tileSize.x.toInt()}x${tileSize.y.toInt()}).png'),
      SpriteAnimationData.sequenced(
        amount: amountOfSprites,
        stepTime: stepTime,
        loop: loop,
        textureSize: tileSize,
      ),
    );
  }

  void _loadAllAnimations() {
    _idleAnimation = _getSpriteAnimation(
        enemiesName: kChickenName,
        state: 'Idle',
        amountOfSprites: enemiesProps[kChickenName]['animations']['idle']
            ['amountOfSprites'],
        stepTime: enemiesProps[kChickenName]['animations']['idle']['stepTime'],
        tileSize: enemiesProps[kChickenName]['tileSize']);
    _runAnimation = _getSpriteAnimation(
        enemiesName: kChickenName,
        state: 'Run',
        amountOfSprites: enemiesProps[kChickenName]['animations']['run']
            ['amountOfSprites'],
        stepTime: enemiesProps[kChickenName]['animations']['run']['stepTime'],
        tileSize: enemiesProps[kChickenName]['tileSize']);
    _hitAnimation = _getSpriteAnimation(
        enemiesName: kChickenName,
        state: 'Hit',
        loop: false,
        amountOfSprites: enemiesProps[kChickenName]['animations']['hit']
            ['amountOfSprites'],
        stepTime: enemiesProps[kChickenName]['animations']['hit']['stepTime'],
        tileSize: enemiesProps[kChickenName]['tileSize']);

    //lista delle animazioni disponib per ogni stato
    animations = {
      ChickenState.idle: _idleAnimation,
      ChickenState.run: _runAnimation,
      ChickenState.hit: _hitAnimation,
    };
    current = ChickenState.idle;
  }

  void _calculateRange() {
    rangeNeg = position.x - offsetNeg * kMapTileSize;
    rangePos = position.x + offsetPos * kMapTileSize;
  }

  void _movement(double dt) {
    velocity.x = 0; //stop poi calcolo
    double playerOffset = (game.player.scale.x > 0) ? 0 : -game.player.width;
    double chickenOffset = (scale.x > 0) ? 0 : -width;
    //se player va a dx nessun offset se no guardo come offset la sua width
    if (playerInRange()) {
      targetDirection =
          (game.player.x + playerOffset < position.x + chickenOffset)
              ? -1 //vado verso il player che sta a sin
              : 1; //vado verso il player che sta a dx
      velocity.x = targetDirection * kChickenSpeed;
    } else {
      velocity.x = 0;
    }
    //in generale:
    moveDirection = lerpDouble(moveDirection, targetDirection, 0.1) ?? 1;
    position.x += velocity.x * dt;
  }

  bool playerInRange() {
    double playerOffset = (game.player.scale.x > 0) ? 0 : -game.player.width;
    return game.player.x + playerOffset >= rangeNeg &&
        game.player.x + playerOffset <= rangePos && //IN RANGE TRA SIN E DX in x
        game.player.y + game.player.height >
            position
                .y && //range in y bottom del player + basso del top del chicken
        game.player.y <
            position.y + height; //top del player + alto del bottom del chicken
  }

  void _updateState() {
    current = (velocity.x != 0) ? ChickenState.run : ChickenState.idle;
    //gallina scale.x > 0 guarda verso sinistra:
    if ((moveDirection > 0 && scale.x > 0) ||
        (moveDirection < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  void collidedWithPlayer() async {
    //COLLISIONE!
    //se ci salto sopra uccido la gallina
    //altrimenti è la gallina che colpisce me
    if (game.player.velocity.y > 0 &&
        game.player.y + game.player.height > position.y) {
      gotStomped = true;
      if (game.playSounds) {
        FlameAudio.play('bounce.wav', volume: game.soundVolume);
      }
      current = ChickenState.hit;
      //faccio rimbalzare il player
      game.player.velocity.y = -enemiesProps[kChickenName]['bounceHeight'];
      //aspetto finisca l'animazione hit
      await animationTicker?.completed;
      removeFromParent();
      //AUMENTA UNA VITA!!!
      game.playerData.health.value++;
    } else {
      game.player.collidedWithEnemy();
    }
  }
}
