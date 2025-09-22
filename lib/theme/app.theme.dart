import 'package:flutter/material.dart';

ThemeData buildTheme(Brightness b) {
  final base = ThemeData(brightness: b, useMaterial3: true);
  return base.copyWith(
    colorScheme: b == Brightness.dark ? const ColorScheme.dark() : const ColorScheme.light(),
    cardTheme: const CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}
