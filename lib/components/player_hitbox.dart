// ignore_for_file: public_member_api_docs, sort_constructors_first
//serve per tener conto delle dimensioni del player dentro il tile
class PlayerHitBox {
  final double offsetX;
  final double offsetY;
  final double width;
  final double height;
  PlayerHitBox({
    required this.offsetX,
    required this.offsetY,
    required this.width,
    required this.height,
  });
}
