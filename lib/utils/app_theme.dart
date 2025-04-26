import 'package:flutter/material.dart';

final ThemeData optiFormaTheme = ThemeData(
  primaryColor: const Color(0xFF00796B),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF00796B),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF00796B),
    secondary: Color(0xFF388E3C),
    surface: Colors.white,
    background: Color(0xFFF5F5F5),
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xFF212121),
    onBackground: Color(0xFF212121),
    onError: Colors.white,
  ),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color(0xFF212121),
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: Color(0xFF212121),
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      color: Color(0xFF757575),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFFFC107),
    foregroundColor: Colors.black,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF388E3C),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 4,
    color: Colors.white,
    shadowColor: Colors.grey.withOpacity(0.2),
  ),
);
