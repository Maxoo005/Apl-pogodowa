import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "app.theme.dart";

final themeModeProvider = StateProvider<ThemeMode>((_) => ThemeMode.system);

final themeProvider = Provider<ThemeData>((ref) {
  final mode = ref.watch(themeModeProvider);
  final brightness = switch (mode) {
    ThemeMode.dark => Brightness.dark,
    ThemeMode.light => Brightness.light,
    _ => WidgetsBinding.instance.platformDispatcher.platformBrightness,
  };
  return buildTheme(brightness);
});
