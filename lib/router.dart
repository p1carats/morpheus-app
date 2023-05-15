import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'ui/wizard/welcome_screen.dart';
import 'ui/wizard/login_screen.dart';
import 'ui/wizard/register_screen.dart';
import 'ui/error_screen.dart';
import 'ui/home_screen.dart';
import 'ui/sleep_screen.dart';
import 'ui/dreams_screen.dart';
import 'ui/settings_screen.dart';
import 'ui/utils/navigation_bar.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return const BottomNavBar();
      },
      routes: <RouteBase>[
        GoRoute(
          name: 'home',
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/sleep',
          builder: (context, state) => const SleepScreen(),
        ),
        GoRoute(
          path: '/dreams',
          builder: (context, state) => const DreamsScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const WizardLoginScreen(),
    ),
    GoRoute(
      name: 'register',
      path: '/register',
      builder: (context, state) => const WizardRegisterScreen(),
    ),
  ],
  errorBuilder: (context, state) => const ErrorScreen(),
);
