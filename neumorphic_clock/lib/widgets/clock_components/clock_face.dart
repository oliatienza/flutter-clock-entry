import 'package:flutter/material.dart';

import '../../constants/clock_values.dart';
import 'clock_marks.dart';
import 'dot_second_hand.dart';
import 'pointed_hand.dart';

class ClockFace extends StatelessWidget {
  const ClockFace({Key key, this.customTheme, this.now}) : super(key: key);

  final ThemeData customTheme;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          const ClockMarks(),
          // Minute hand
          PointedHand(
            color: customTheme.highlightColor,
            baseSize: 15,
            size: 0.75,
            angleRadians: now.minute * radiansPerTick,
          ),
          // Hour hand
          PointedHand(
            color: customTheme.primaryColor,
            baseSize: 15,
            size: 0.5,
            angleRadians:
                now.hour * radiansPerHour + (now.minute / 60) * radiansPerHour,
          ),
          // Second dot
          DotSecondHand(radius: 3.5, angleRadians: now.second * radiansPerTick),
          Center(
            child: SizedBox(
              height: 17.5,
              width: 17.5,
              child: Material(
                shape: const CircleBorder(),
                color: customTheme.accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
