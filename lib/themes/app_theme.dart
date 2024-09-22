import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF76abae);
  static const Color secondaryColor = Color(0xFF31363f);
  static const Color backgroundColor = Color(0xFFeeeeee);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: backgroundColor,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.black),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: secondaryColor,
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        backgroundColor: secondaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: backgroundColor,
        surface: secondaryColor,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
      ),
      useMaterial3: true,
    );
  }
}
