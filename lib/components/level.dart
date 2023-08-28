// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/background_tile.dart';
import 'package:pixel_adventure/components/collision_block.dart';

import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/constants/game_constants.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class LevelComponent extends World with HasGameRef<PixelAdventure> {
  final String levelName;
  final Player player;
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];
  LevelComponent({required this.levelName, required this.player});

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(kTileSize));

    add(level); //agg al gioco

    _scrollingBackground();
    _spawningObjects();
    _addCollisions();

    return super.onLoad();
  }

  void _scrollingBackground() {
    final backgroundLayer =
        level.tileMap.getLayer("Background"); //non è un objectGroup
    const tileSize = kBackgroundTileSize;
    final numTilesY = (game.size.y / tileSize).floor();
    final numTilesX = (game.size.x / tileSize).floor();
    if (backgroundLayer != null) {
      final String? backgroundColor =
          backgroundLayer.properties.getValue("backgroundColor");
      for (var y = 0; y <= numTilesY; y++) {
        //<= per non lasciare gap
        for (var x = 0; x < numTilesX; x++) {
          final backGroundTile = BackgroundTile(
              color: backgroundColor ?? 'Gray',
              position: Vector2(
                  x * tileSize - tileSize,
                  y * tileSize -
                      tileSize)); //il meno è per far partire un po' prima della camera e non vederlo subito scrollare
          add(backGroundTile);
        }
      }
    }
  }

  void _spawningObjects() {
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
  }

  void _addCollisions() {
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
  }
}
