import 'package:flutter/material.dart';

class ExampleAppTheme {
  static final lightThemeData = ThemeData(
      useMaterial3: false,
      primarySwatch: Colors.green,
      colorScheme: ColorScheme.light(
        primary: Colors.green,
        secondary: Colors.grey,
        background: Colors.white,
        onBackground: Colors.black,
        outline: Colors.grey.shade200,
        outlineVariant: Colors.grey.shade200,
        primaryContainer: const Color(0xFFD2FFB4),
        onSurface: Colors.grey.shade100,
      ),
      snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.black87,
          contentTextStyle: TextStyle(color: Colors.white),
          showCloseIcon: true,
          closeIconColor: Colors.white70,
      ),
      textTheme: const TextTheme(
        titleSmall: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0),
        titleMedium: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 0),
        titleLarge: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 0),
        bodyMedium: TextStyle(fontSize: 14, letterSpacing: 0),
        labelSmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0),
        labelMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            letterSpacing: 0),
        labelLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0),
      ));

  static final darkThemeData = ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: Colors.green,
        secondary: Colors.grey.shade600,
        background: Colors.grey.shade900,
        onBackground: Colors.white,
        outline: Colors.grey.shade700,
        outlineVariant: Colors.white54,
        primaryContainer: const Color(0xFF7FA864),
        onSurface: Colors.grey.shade800,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Colors.black87,
        contentTextStyle: TextStyle(color: Colors.white),
        showCloseIcon: true,
        closeIconColor: Colors.white70,
      ),
      textTheme: const TextTheme(
        titleSmall: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0),
        titleMedium: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 0),
        titleLarge: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 0),
        bodyMedium: TextStyle(fontSize: 14, letterSpacing: 0),
        labelSmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0),
        labelMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0),
        labelLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0),
      ));

  ExampleAppTheme._();
}

ColorScheme getColorTheme(BuildContext context) =>
    Theme.of(context).colorScheme;

TextTheme getTextTheme(BuildContext context) => Theme.of(context).textTheme;
