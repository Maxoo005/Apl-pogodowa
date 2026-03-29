import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "features/home/home_screen.dart";
import "/../features/locations/presentation/locations_screen.dart";
import "settings/settings_screen.dart";

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (ctx, st) => const MaterialPage(child: HomeScreen()),
    ),
    GoRoute(
      path: '/locations',
      pageBuilder: (ctx, st) => const MaterialPage(child: LocationsScreen()),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (ctx, st) => const MaterialPage(child: SettingsScreen()),
    ),
  ],
);
