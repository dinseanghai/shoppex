import 'package:flutter/material.dart';

abstract class AppTextStyles {
  static const String _fontFamily = 'Roboto';

  static final TextStyle displayLarge_primary = TextStyle(
      fontFamily: _fontFamily,
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
      color: Color(0xFF4D5EBE)
  );

  static final TextStyle displayLarge_Secondary = TextStyle(
      fontFamily: _fontFamily,
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: Color(0xFF000000)
  );

  static final TextStyle displaySmall_Primary = TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16.0,
      color: Color(0xFF000000)
  );

  static final TextStyle displaySmall_Secondary = TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16.0,
      color: Color(0xFF757575)
  );

  static final TextStyle buttonPrimary = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  );
}