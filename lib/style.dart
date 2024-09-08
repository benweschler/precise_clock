import 'package:flutter/material.dart';

abstract class Insets {
  static const double xs = 5;
  static const double sm = 10;
  static const double med = 15;
  static const double lg = 20;
  static const double xl = 30;

  /// The offset of every page from the border of the device.
  static const double offset = 15;
}

abstract class TextStyles {
  static const TextStyle h1 = TextStyle(fontSize: 32, fontWeight: FontWeight.bold);
  static const TextStyle title1 = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2);
  static const TextStyle body1 = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static const TextStyle body2 = TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
  static const TextStyle caption = TextStyle(fontSize: 12, fontWeight: FontWeight.normal);
}

abstract class Timings {
  static const Duration long = Duration(milliseconds: 300);
}
