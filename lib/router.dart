import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'ui/auth/auth_screen.dart';
import 'ui/auth/login_screen.dart';
import 'ui/auth/register_screen.dart';

import 'ui/wizard/welcome_screen.dart';
import 'ui/error_screen.dart';
import 'ui/home_screen.dart';
import 'ui/sleep_screen.dart';
import 'ui/dreams_screen.dart';
import 'ui/add_dream_screen.dart';

import 'ui/settings/settings_screen.dart';
import 'ui/settings/email_screen.dart';
import 'ui/settings/data_screen.dart';
import 'ui/utils/navigation_bar.dart';

final GoRouter router = GoRouter(
  initialLocation: '/auth',
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
      name: 'email',
      path: '/email',
      builder: (context, state) => const SettingsEmailScreen(),
    ),
    GoRoute(
      name: 'data',
      path: '/data',
      builder: (context, state) => const SettingsDataScreen(),
    ),
    GoRoute(
      name: 'auth',
      path: '/auth',
      builder: (context, state) => const AuthMainScreen(),
      routes: <RouteBase>[
        GoRoute(
          name: 'login',
          path: 'login',
          builder: (context, state) => AuthLoginScreen(),
        ),
        GoRoute(
          name: 'register',
          path: 'register',
          builder: (context, state) => AuthRegisterScreen(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const ErrorScreen(),
);
