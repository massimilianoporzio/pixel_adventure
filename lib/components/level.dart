// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/collision_block.dart';

import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/constants/game_constants.dart';

class LevelComponent extends World {
  final String levelName;
  final Player player;
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];
  LevelComponent({required this.levelName, required this.player});

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(kTileSize));

    add(level); //agg al gioco
    //tiro fuori il layer degli oggetti
    final spawnpointsLayer = level.tileMap.getLayer<ObjectGroup>("Spawnpoints");
    if (spawnpointsLayer != null) {
//loop tra gli ogg del layer
      for (var obj in spawnpointsLayer.objects) {
        switch (obj.class_) {
          case 'Player':
            player.position = Vector2(obj.x, obj.y);
            add(player);
            break;

          default:
        }
      }
    }
    final collisionLayer = level.tileMap.getLayer<ObjectGroup>("Collisions");
    if (collisionLayer != null) {
      for (var obj in collisionLayer.objects) {
        switch (obj.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(obj.x, obj.y),
              size: Vector2(obj.width, obj.height),
              isPlatform: true,
            );
            collisionBlocks.add(
                platform); //agg alla lista di modo che altrove posso usarli
            add(platform);
            break;
          default:
            final block = CollisionBlock(
                position: Vector2(obj.x, obj.y),
                size: Vector2(obj.width, obj.height));
            collisionBlocks
                .add(block); //agg alla lista di modo che altrove posso usarli
            add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
    return super.onLoad();
  }
}
