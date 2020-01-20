import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class ClockMarks extends StatelessWidget {
  const ClockMarks(
      {Key key,
      this.divisions = 12,
      this.radius = 2.5,
      this.color = LIGHT_CLOCK_MARK_COLOR,
      this.padding = 7.5})
      : super(key: key);

  final int divisions;
  final double radius;
  final Color color;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _MarksPainter(
              divisions: divisions,
              radius: radius,
              color: color,
              padding: padding),
        ),
      ),
    );
  }
}

class _MarksPainter extends CustomPainter {
  _MarksPainter({
    @required this.divisions,
    @required this.radius,
    @required this.color,
    @required this.padding,
  })  : assert(divisions != null),
        assert(radius != null),
        assert(color != null),
        assert(divisions > 0);

  int divisions;
  double radius;
  double padding;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = (Offset.zero & size).center;

    final Paint paint = Paint()..color = color;
    final double angleIncrement = 2 * math.pi / divisions;

    for (int i = 0; i < divisions; i++) {
      final Offset position = center +
          Offset(math.cos(angleIncrement * i), math.sin(angleIncrement * i)) *
              (size.height / 2 - padding);
      canvas.drawCircle(position, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_MarksPainter oldDelegate) {
    // return oldDelegate.handSize != handSize ||
    //     oldDelegate.lineWidth != lineWidth ||
    //     oldDelegate.angleRadians != angleRadians ||
    //     oldDelegate.color != color;
    return true;
  }
}
