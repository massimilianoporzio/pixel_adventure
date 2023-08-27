import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device
      .fullScreen(); //ASYNC importante è per physical phone se no mette il joystick in posti sbagliati
  await Flame.device.setLandscape();
  final game = PixelAdventure(); // per produzione
  runApp(GameWidget(game: kDebugMode ? PixelAdventure() : game));
}
