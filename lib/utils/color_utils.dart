import 'dart:math';
import 'package:flutter/material.dart';

Color get randomColor {
  HSLColor hsl =
      HSLColor.fromColor(Color((Random().nextDouble() * 0xFFFFFF).toInt()));
  return hsl.withLightness(max(hsl.lightness, 0.70)).toColor().withOpacity(1.0);
}

Color changeColorLightness(Color color, double amount) {
  HSLColor hsl = HSLColor.fromColor(color);
  return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
}

double getLightness(Color color) {
  return HSLColor.fromColor(color).lightness;
}
