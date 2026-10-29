import 'package:flutter/material.dart';

ThemeData appTheme() => ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFB5E48C),
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: const Color(0xFF141222),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    filled: true,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
  ),
);
