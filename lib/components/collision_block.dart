import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  bool isPlatform;
  CollisionBlock({super.position, super.size, this.isPlatform = false}) {
    debugMode =
        false; //sono trasparenti! disegnati secondo il livello dove nel background c'è qualcosa
  }
}
