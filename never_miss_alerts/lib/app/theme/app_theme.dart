import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF635BFF);
  static const Color background = Color(0xFFF7F7FB);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
      fontFamily: 'Roboto',
    );
  }
}
