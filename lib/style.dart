import 'package:flutter/material.dart';

class Insets {
  static double get offset => 10;

  static double get spacer => 20;

  static double get med => 10;
}

class Shadows {
  static List<BoxShadow> get universal => [
    const BoxShadow(
      color: Colors.black,
      offset: Offset(0, 4),
      spreadRadius: 1,
      blurRadius: 5,
    ),
  ];
}

class TextStyles {
  static TextStyle get title =>
      const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static TextStyle get subtitle =>
      const TextStyle(fontSize: 24, fontWeight: FontWeight.w500);

  static TextStyle get h1 =>
      const TextStyle(fontSize: 20, fontWeight: FontWeight.normal);
}
