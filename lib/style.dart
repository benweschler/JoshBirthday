import 'package:flutter/material.dart';

class Insets {
  static double get offset => 10;

  static double get spacer => 30;

  static double get med => 10;

  static double get lg => 15;
}

class Corners {
  static BorderRadius get smBorderRadius => BorderRadius.circular(5.0);

  static BorderRadius get medBorderRadius => BorderRadius.circular(10.0);
}

class TextStyles {
  static TextStyle get title =>
      const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static TextStyle get subtitle =>
      const TextStyle(fontSize: 24, fontWeight: FontWeight.w500);

  static TextStyle get h1 =>
      const TextStyle(fontSize: 20, fontWeight: FontWeight.normal);
}
