import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'ui/wizard/welcome_screen.dart';
import 'ui/wizard/auth_screen.dart';
import 'ui/wizard/login_screen.dart';
import 'ui/wizard/register_screen.dart';
import 'ui/error_screen.dart';
import 'ui/home_screen.dart';
import 'ui/sleep_screen.dart';
import 'ui/dreams_screen.dart';
import 'ui/add_dream_screen.dart';
import 'ui/settings/settings_screen.dart';
import 'ui/settings/profile_screen.dart';
import 'ui/settings/data_screen.dart';
import 'ui/utils/navigation_bar.dart';

final GoRouter router = GoRouter(
  initialLocation: 'auth',
  //FirebaseAuth.instance.currentUser != null ? '/home' : '/auth',
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
          name: 'sleep',
          path: '/sleep',
          builder: (context, state) => const SleepScreen(),
        ),
        GoRoute(
          name: 'dreams',
          path: '/dreams',
          builder: (context, state) => const DreamsScreen(),
          routes: <RouteBase>[
            GoRoute(
              name: 'dream-add',
              path: 'add',
              builder: (context, state) => const AddDreamScreen(),
            ),
          ],
        ),
        GoRoute(
          name: 'settings',
          path: '/settings',
          builder: (context, state) => const SettingsMainScreen(),
        ),
      ],
    ),
    GoRoute(
      name: 'profile',
      path: '/profile',
      builder: (context, state) => const SettingsProfileScreen(),
    ),
    GoRoute(
      name: 'data',
      path: '/data',
      builder: (context, state) => const SettingsDataScreen(),
    ),
    GoRoute(
      name: 'auth',
      path: '/auth',
      builder: (context, state) => const WizardAuthScreen(),
      routes: <RouteBase>[
        GoRoute(
          name: 'login',
          path: 'login',
          builder: (context, state) => const WizardLoginScreen(),
        ),
        GoRoute(
          name: 'register',
          path: 'register',
          builder: (context, state) => const WizardRegisterScreen(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const ErrorScreen(),
);
