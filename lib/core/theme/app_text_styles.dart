import 'package:flutter/material.dart';

abstract class AppTextStyles {
  static const String _fontFamily = 'Roboto';

  static final TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static final TextStyle buttonPrimary = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
}