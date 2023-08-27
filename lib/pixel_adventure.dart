import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:pixel_adventure/levels/level.dart';

import 'actors/player.dart';

class PixelAdventure extends FlameGame with HasKeyboardHandlerComponents {
  //stesso colore del background assegnato al background di TUTTA LA APP
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  //perché mi faccia vedere qualcosa serve una camera
  late final CameraComponent cam;
  Player player = Player(character: 'Mask Dude');

  @override
  FutureOr<void> onLoad() async {
    //LOAD ALL in cache..se troppe faccio solo load una alla vola quelle che servono per partire
    await images.loadAllImages();
    //definisco il mondo con un livello e un giocatore (dopo aver caricato le immaggini)
    final world = LevelComponent(levelName: 'Level-01', player: player);
    //640x368 sono le dim della mappa in Tiled
    cam = CameraComponent.withFixedResolution(
        width: 640, height: 360, world: world)
      ..viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);

    return super.onLoad();
  }
}
