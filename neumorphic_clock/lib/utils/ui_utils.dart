import 'package:flutter/material.dart';

import '../constants/colors.dart';

Color getWeatherColor(String weather, Brightness brightness) {
  final bool isLightMode = brightness == Brightness.light;

  if (<String>['sunny'].contains(weather)) {
    return isLightMode ? LIGHT_WEATHER_YELLOW : LIGHT_WEATHER_YELLOW;
  }

  if (<String>['cloudy', 'windy'].contains(weather)) {
    return isLightMode ? LIGHT_WEATHER_GREY : LIGHT_WEATHER_GREY;
  }

  if (<String>['snowy'].contains(weather)) {
    return isLightMode ? LIGHT_WEATHER_SKY_BLUE : LIGHT_WEATHER_SKY_BLUE;
  }

  return isLightMode ? LIGHT_WEATHER_BLUE : LIGHT_WEATHER_BLUE;
}
