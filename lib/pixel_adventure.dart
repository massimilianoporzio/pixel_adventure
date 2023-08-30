import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/jump_button.dart';
import 'package:pixel_adventure/components/level.dart';
import 'package:pixel_adventure/components/models/player_data.dart';

import 'components/hud.dart';
import 'components/player.dart';

class PixelAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  //per ora gestisco qui globalmente
  final playerData = PlayerData();
  bool isMobile = defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.fuchsia ||
      defaultTargetPlatform == TargetPlatform.iOS;
  //stesso colore del background assegnato al background di TUTTA LA APP
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  //perché mi faccia vedere qualcosa serve una camera
  late CameraComponent cam;
  Player player = Player(character: 'Mask Dude');
  late JoystickComponent joystick;
  late JumpButton jumpButton;
  late Hud hud;
  bool showControls = false;
  bool playSounds = true;
  double soundVolume = 1.0;
  List<String> levelNames = ['Level-01', 'Level-01'];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    //check se è su mobile
    showControls = isMobile;

    //LOAD ALL in cache..se troppe faccio solo load una alla vola quelle che servono per partire
    await images.loadAllImages();
    _loadLevel();

    if (showControls) {
      addJoystick();
      addJumpBotton();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls) {
      _updateJoystick();
    }

    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 10, //davanti a tutti
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
    )..scale = Vector2.all(1.4);
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

  void loadNextLevel() {
    removeWhere((component) =>
        component is LevelComponent); //rimuovo il livello e l'hud
    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      //NO MORE LEVELS
      restartGame();
    }
  }

  void restartGame() {
    removeWhere((component) => component is LevelComponent);
    currentLevelIndex = 0;
    playerData.score.value = 0;
    playerData.health.value = 5;
    _loadLevel(); //riparto dal livello 1
  }

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
//definisco il mondo con un livello e un giocatore (dopo aver caricato le immaggini)
      LevelComponent world = LevelComponent(
        levelName: levelNames[currentLevelIndex],
        player: player,
      );
      add(world);
      //640x368 sono le dim della mappa in Tiled
      cam = CameraComponent.withFixedResolution(
          width: 638.1, height: 360, world: world)
        ..viewfinder.anchor = Anchor.topLeft;
      cam.viewport.add(Hud());
      add(cam);
    });
  }

  void addJumpBotton() {
    jumpButton = JumpButton();
    add(jumpButton);
  }
}
