import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/constants/game_constants.dart';

class LevelComponent extends World {
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(
        'Level-01.tmx', Vector2.all(GameConstants.kTileSize));

    add(level); //agg al gioco
    return super.onLoad();
  }
}
