class Bullet {
  final String id;
  double x;
  double y;
  final double angle;
  final double speed;
  final String ownerId;

  Bullet({
    required this.id,
    required this.x,
    required this.y,
    required this.angle,
    this.speed = 12.0, // Увеличено с 10.0
    required this.ownerId,
  });
}