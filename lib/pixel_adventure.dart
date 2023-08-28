import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/level.dart';

import 'components/player.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  bool isMobile = defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.fuchsia ||
      defaultTargetPlatform == TargetPlatform.iOS;
  //stesso colore del background assegnato al background di TUTTA LA APP
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  //perché mi faccia vedere qualcosa serve una camera
  late final CameraComponent cam;
  Player player = Player(character: 'Mask Dude');
  late JoystickComponent joystick;
  bool showJoystick = false;

  @override
  FutureOr<void> onLoad() async {
    //check se è su mobile
    showJoystick = isMobile;
    //LOAD ALL in cache..se troppe faccio solo load una alla vola quelle che servono per partire
    await images.loadAllImages();
    //definisco il mondo con un livello e un giocatore (dopo aver caricato le immaggini)
    final world = LevelComponent(levelName: 'Level-01', player: player);
    //640x368 sono le dim della mappa in Tiled
    cam = CameraComponent.withFixedResolution(
        width: 640, height: 360, world: world)
      ..viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);

    if (showJoystick) {
      addJoystick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      _updateJoystick();
    }

    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(
        left: 16,
        bottom: 16,
      ),
    );
    add(joystick);
  }

  void _updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalInput = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalInput = 1;
        break;
      default:
        // idle
        player.horizontalInput = 0;
        break;
    }
  }
}
