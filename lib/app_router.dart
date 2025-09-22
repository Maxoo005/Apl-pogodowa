import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/home/home_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      pageBuilder: (ctx, st) => const MaterialPage(child: HomeScreen()),
    ),
  ],
);
