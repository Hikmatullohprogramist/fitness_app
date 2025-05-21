import 'package:flutter/material.dart';

final ThemeData optiFormaTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF9F5F91),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF9F5F91),
    primary: const Color(0xFF9F5F91),
    secondary: const Color(0xFF572C57),
    error: const Color(0xFFE26972),
    background: const Color(0xFFF5F5F5),
    surface: const Color(0xFFF6EA98),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onError: Colors.white,
    onBackground: Colors.black87,
    onSurface: Colors.black87,
    brightness: Brightness.light,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF572C57),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF9F5F91),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFE26972),
    foregroundColor: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF6EA98).withOpacity(0.15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF9F5F91)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF572C57), width: 2),
    ),
    labelStyle: const TextStyle(color: Color(0xFF9F5F91)),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
        fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF572C57)),
    titleLarge: TextStyle(
        fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF9F5F91)),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
    labelLarge: TextStyle(fontSize: 14, color: Color(0xFF572C57)),
  ),
);
