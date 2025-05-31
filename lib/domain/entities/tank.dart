class Tank {
  final String id;
  double x;
  double y;
  double angle;
  final double speed;
  final double rotationSpeed;
  int health;

  Tank({
    required this.id,
    required this.x,
    required this.y,
    this.angle = 0,
    this.speed = 5.0,
    this.rotationSpeed = 0.1,
    this.health = 100,
  });
}