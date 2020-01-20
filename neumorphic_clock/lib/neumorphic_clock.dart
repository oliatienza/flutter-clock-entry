// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:analog_clock/constants/colors.dart';
import 'package:analog_clock/utils/string_utils.dart';
import 'package:analog_clock/utils/ui_utils.dart';
import 'package:analog_clock/widgets/animated_neumorphic_container.dart';
import 'package:analog_clock/widgets/clock_components/clock_face.dart';
import 'package:analog_clock/widgets/dot_grid.dart';
import 'package:analog_clock/widgets/fade_in_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);

  final ClockModel model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  DateTime _now = DateTime.now();
  String _temperature = '';
  String _location = '';
  String _weather = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString.split('.')[0];
      _location = widget.model.location;
      _weather = widget.model.weatherString;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      _timer = Timer(
        const Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set orientation and fullscreen
    SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[]);
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    final ThemeData customTheme = isLightMode
        ? Theme.of(context).copyWith(
            // Hour hand.
            primaryColor: LIGHT_HOUR_HAND_COLOR,
            // Minute hand.
            highlightColor: LIGHT_MINUTE_HAND_COLOR,
            // Second hand.
            accentColor: LIGHT_PRIMARY_COLOR,
            backgroundColor: LIGHT_BACKGROUND_COLOR,
          )
        : Theme.of(context).copyWith(
            primaryColor: DARK_HOUR_HAND_COLOR,
            highlightColor: DARK_MINUTE_HAND_COLOR,
            accentColor: DARK_PRIMARY_COLOR,
            backgroundColor: DARK_BACKGROUND_COLOR,
          );

    final String time = DateFormat('h:mm a').format(DateTime.now());
    final String time24hr = DateFormat('HH:mm').format(DateTime.now());
    final TextStyle textStyle = GoogleFonts.quicksand(
      textStyle: TextStyle(
        color: isLightMode ? Colors.black54 : Colors.white54,
        fontSize: 14,
      ),
    );

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Stack(
        children: <Widget>[
          Container(
            color: customTheme.backgroundColor,
          ),
          Positioned(
            top: 32,
            left: 32,
            child: FadeInAnimation(
              child: DotGrid(
                color: customTheme.accentColor,
                rows: 4,
                columns: 5,
                radius: 6,
                spacing: 25,
              ),
            ),
          ),
          Positioned(
            right: 24,
            bottom: 24,
            child: FadeInAnimation(
              child: DotGrid(
                color: customTheme.accentColor,
                rows: 5,
                columns: 4,
                radius: 6,
                spacing: 25,
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 64),
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.height * 0.6,
                  child: AnimatedNeumorphicContainer(
                    delay: const Duration(seconds: 1),
                    child: ClockFace(
                      customTheme: customTheme,
                      now: _now,
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AnimatedNeumorphicContainer(
                      delay: const Duration(seconds: 2),
                      child: Text(
                        widget.model.is24HourFormat ? time24hr : time,
                        style: textStyle.copyWith(
                            fontWeight: FontWeight.normal, fontSize: 24),
                      ),
                    ),
                    const SizedBox(height: 28),
                    AnimatedNeumorphicContainer(
                      delay: const Duration(seconds: 3),
                      child: Column(
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/svg/' + _weather + '.svg',
                            height: 40,
                            color: getWeatherColor(
                                _weather, Theme.of(context).brightness),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Text(
                                  '°C',
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      color: Colors.transparent,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _temperature,
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    color: isLightMode
                                        ? Colors.black26
                                        : Colors.white24,
                                    fontSize: 48,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Text(
                                  widget.model.temperatureString.substring(
                                      widget.model.temperatureString.length -
                                          2),
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      color: isLightMode
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Text(
                            toTitleCase(_location),
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 64),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
