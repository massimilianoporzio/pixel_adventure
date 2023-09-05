// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/background_tile.dart';
import 'package:pixel_adventure/components/checkpoint.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/enemies/chicken.dart';
import 'package:pixel_adventure/components/fruit.dart';

import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/constants/game_constants.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

import 'saw.dart';

class LevelComponent extends World with HasGameRef<PixelAdventure> {
  final String levelName;
  final Player player;
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];
  LevelComponent({required this.levelName, required this.player});

  @override
  FutureOr<void> onLoad() async {
    level =
        await TiledComponent.load('$levelName.tmx', Vector2.all(kMapTileSize));
    level.debugMode = false;
    add(level); //agg al gioco

    _scrollingBackground();
    _spawningObjects();
    _addCollisions();

    return super.onLoad();
  }

  void _scrollingBackground() {
    final backgroundLayer =
        level.tileMap.getLayer("Background"); //non è un objectGroup

    if (backgroundLayer != null) {
      final String? backgroundColor =
          backgroundLayer.properties.getValue("backgroundColor");
      final backgroundTile = BackgroundTile(
        color: backgroundColor ?? "Gray",
        position: Vector2.zero(),
      );
      add(backgroundTile);
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
            player.scale.x = 1.0; //sempre a dx
            add(player);
            break;
          case 'Fruit':
            final fruit = Fruit(
              position: Vector2(obj.x, obj.y),
              size: Vector2(obj.width, obj.height),
              fruitName:
                  obj.name, //presuppone che su Tiled il nome sia corretto!!!
            );
            add(fruit);
            break;
          case 'Saw':
            final isVertical = obj.properties.getValue("isVertical");
            final offsetNeg = obj.properties.getValue("offsetNeg");
            final offsetPos = obj.properties.getValue("offsetPos");
            final saw = Saw(
              position: Vector2(obj.x, obj.y),
              size: Vector2(obj.width, obj.height),
              isVertical: isVertical,
              offsetNeg: offsetNeg,
              offsetPos: offsetPos,
            );
            add(saw);
            break;
          case 'Checkpoint':
            final checpoint = CheckPoint(
                position: Vector2(obj.x, obj.y),
                size: Vector2(obj.width, obj.height));
            add(checpoint);
            break;
          case 'Chicken':
            final offsetNeg = obj.properties.getValue('offsetNeg');
            final offsetPos = obj.properties.getValue('offsetPos');
            final chicken = Chicken(
              position: Vector2(obj.x, obj.y),
              size: Vector2(obj.width, obj.height),
              offsetNeg: offsetNeg,
              offsetPos: offsetPos,
            );
            add(chicken);
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
