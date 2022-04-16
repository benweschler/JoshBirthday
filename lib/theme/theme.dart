import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

class AppTheme {
  static ThemeData getTheme() {
    Color backgroundColor = randomBackgroundColor();
    Color accentColor = changeColorLightness(backgroundColor, -0.35);

    return ThemeData(
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ThemeData().colorScheme.copyWith(
            primary: accentColor,
            secondary: accentColor,
          ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(accentColor)
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(accentColor),
          overlayColor: MaterialStateProperty.all(
            accentColor.withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}
