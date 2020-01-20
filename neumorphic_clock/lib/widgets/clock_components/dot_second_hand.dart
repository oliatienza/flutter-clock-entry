import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class DotSecondHand extends StatelessWidget {
  const DotSecondHand(
      {Key key,
      this.radius,
      this.angleRadians,
      this.color = LIGHT_PRIMARY_COLOR})
      : super(key: key);

  final double radius;
  final double angleRadians;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _DotPainter(
              radius: radius, angleRadians: angleRadians, color: color),
        ),
      ),
    );
  }
}

class _DotPainter extends CustomPainter {
  _DotPainter({
    @required this.radius,
    @required this.angleRadians,
    @required this.color,
  })  : assert(radius != null),
        assert(angleRadians != null),
        assert(color != null),
        assert(radius >= 0.0);

  double radius;
  double angleRadians;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = (Offset.zero & size).center;
    final double angle = angleRadians - math.pi / 2.0;
    final Offset position = center +
        Offset(math.cos(angle), math.sin(angle)) * (size.height / 2 - 7.5);
    final Paint paint = Paint()..color = color;

    canvas.drawCircle(position, radius, paint);
  }

  @override
  bool shouldRepaint(_DotPainter oldDelegate) {
    return oldDelegate.radius != radius ||
        oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
  }
}
