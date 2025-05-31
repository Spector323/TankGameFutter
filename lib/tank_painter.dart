import 'package:flutter/material.dart';

class TankPainter extends CustomPainter {
  final double bodyAngle;
  final double turretAngle;
  final Color color;

  TankPainter({
    required this.bodyAngle,
    required this.turretAngle,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final center = Offset(size.width / 2, size.height / 2);

    // Корпус танка (прямоугольник)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(bodyAngle);
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: 30, height: 20),
      paint,
    );
    canvas.restore();

    // Башня (круг + пулемет)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(turretAngle);
    // Круг башни
    canvas.drawCircle(Offset.zero, 10, paint);
    // Пулемет (короче, чем ствол)
    paint.color = Colors.grey;
    canvas.drawRect(
      Rect.fromLTWH(0, -1, 15, 2),
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(TankPainter oldDelegate) {
    return oldDelegate.bodyAngle != bodyAngle ||
        oldDelegate.turretAngle != turretAngle ||
        oldDelegate.color != color;
  }
}