// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'hand.dart';

class PointedHand extends Hand {
  const PointedHand(
      {@required Color color,
      @required double size,
      @required double angleRadians,
      @required this.baseSize})
      : assert(color != null),
        assert(size != null),
        assert(angleRadians != null),
        super(
          color: color,
          size: size,
          angleRadians: angleRadians,
        );

  final double baseSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _HandPainter(
            handSize: size,
            angleRadians: angleRadians,
            color: color,
            baseSize: baseSize,
          ),
        ),
      ),
    );
  }
}

/// [CustomPainter] that draws a pointed clock hand.
class _HandPainter extends CustomPainter {
  _HandPainter(
      {@required this.angleRadians,
      @required this.color,
      @required this.handSize,
      @required this.baseSize})
      : assert(handSize != null),
        assert(angleRadians != null),
        assert(color != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0);

  double handSize;
  double angleRadians;
  double baseSize;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = (Offset.zero & size).center;
    // We want to start at the top, not at the x-axis, so add pi/2.
    final double angle = angleRadians - math.pi / 2.0;
    final double length = size.shortestSide * 0.5 * handSize;

    // The tip of the pointed corner
    final Offset tip =
        center + Offset(math.cos(angle), math.sin(angle)) * length;

    // Setup the coordinates of the base
    final double baseOffsetAngle1 = angle - math.pi / 2.0;
    final double baseOffsetAngle2 = angle + math.pi / 2.0;

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.square;

    canvas.drawLine(
        center,
        tip +
            Offset(math.cos(angle - math.pi) * baseSize,
                math.sin(angle - math.pi) * baseSize),
        paint);

    final Offset arrowBase =
        center + Offset(math.cos(angle), math.sin(angle)) * (length - 12.5);
    final Offset arrowBaseOffset1 = arrowBase +
        Offset(math.cos(baseOffsetAngle1), math.sin(baseOffsetAngle1)) *
            (baseSize / 2);
    final Offset arrowBaseOffset2 = arrowBase +
        Offset(math.cos(baseOffsetAngle2), math.sin(baseOffsetAngle2)) *
            (baseSize / 2);

    // Path to create the arrow
    final Path path2 = Path();
    path2.moveTo(arrowBaseOffset1.dx, arrowBaseOffset1.dy);
    path2.lineTo(arrowBaseOffset2.dx, arrowBaseOffset2.dy);
    path2.lineTo(tip.dx, tip.dy);
    path2.close();

    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(_HandPainter oldDelegate) {
    return oldDelegate.handSize != handSize ||
        oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
  }
}
