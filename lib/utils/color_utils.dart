import 'dart:math';
import 'package:flutter/material.dart';

Color get randomColor {
  HSLColor hsl =
      HSLColor.fromColor(Color((Random().nextDouble() * 0xFFFFFF).toInt()));
  return hsl.withLightness(max(hsl.lightness, 0.3)).toColor().withOpacity(1.0);
}
