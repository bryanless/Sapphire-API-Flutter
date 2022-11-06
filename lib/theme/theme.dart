import 'package:flutter/material.dart';

class DynamicTheme {
  static ThemeData lightTheme(ColorScheme? lightColorScheme) {
    ColorScheme scheme = lightColorScheme ??
        ColorScheme.fromSeed(
          seedColor: Colors.blue,
        );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
    );
  }

  static ThemeData darkTheme(ColorScheme? darkColorScheme) {
    ColorScheme scheme = darkColorScheme ??
        ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
    );
  }
}
