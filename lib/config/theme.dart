import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: const Color(0xFFf0512a),
      onPrimary: Colors.white,
      secondary: Colors.yellow.shade700,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      background: const Color(0xFFF5F5F5),
      onBackground: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Futura",
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Color(0xFF1B070B),
        fontWeight: FontWeight.bold,
        fontSize: 36,
      ),
      headline2: TextStyle(
        color: Color(0xFF1B070B),
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      headline3: TextStyle(
        color: Color(0xFF1B070B),
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      headline4: TextStyle(
        color: Color(0xFF1B070B),
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      headline5: TextStyle(
        color: Color(0xFF1B070B),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      headline6: TextStyle(
        color: Color(0xFF1B070B),
        fontWeight: FontWeight.normal,
        fontSize: 14,
      ),
      bodyText1: TextStyle(
        color: Color(0xFF1B070B),
        fontWeight: FontWeight.normal,
        fontSize: 12,
      ),
      bodyText2: TextStyle(
        color: Color(0xFF1B070B),
        fontWeight: FontWeight.normal,
        fontSize: 10,
      ),
    ),
  );
}
