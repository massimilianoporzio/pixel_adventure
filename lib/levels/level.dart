// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'package:pixel_adventure/actors/player.dart';
import 'package:pixel_adventure/constants/game_constants.dart';

class LevelComponent extends World {
  final String levelName;
  late TiledComponent level;
  LevelComponent({
    required this.levelName,
  });

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(kTileSize));

    add(level); //agg al gioco
    //tiro fuori il layer degli oggetti
    final objectsLayer = level.tileMap.getLayer<ObjectGroup>("Objects");
    //loop tra gli ogg del layer
    for (var obj in objectsLayer!.objects) {
      switch (obj.class_) {
        case 'Player':
          final player = Player(
              character: kNinjaFrogName, position: Vector2(obj.x, obj.y));
          add(player);
          break;

        default:
      }
    }
    //il player l'ho caricato girando tra gli oggetti
    //add(Player(character: kNinjaFrogName)); //creo player e aggiungo
    return super.onLoad();
  }
}
