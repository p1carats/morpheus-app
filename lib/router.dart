import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'ui/auth/auth_screen.dart';
import 'ui/auth/login_screen.dart';
import 'ui/auth/register_screen.dart';

import 'ui/wizard/welcome_screen.dart';
import 'ui/utils/navigation_bar.dart';
import 'ui/error_screen.dart';
import 'ui/home_screen.dart';
import 'ui/analytics_screen.dart';
import 'ui/sleep_screen.dart';
import 'ui/dreams_screen.dart';
import 'ui/add_dream_screen.dart';

import 'ui/settings/settings_screen.dart';
import 'ui/settings/data_screen.dart';
import 'ui/settings/profile_screen.dart';
import 'ui/settings/email_screen.dart';
import 'ui/settings/password_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: '/auth',
  navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return const BottomNavBar();
      },
      routes: <RouteBase>[
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          name: 'home',
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          name: 'analytics',
          path: '/analytics',
          builder: (context, state) => const AnalyticsMainScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          name: 'sleep',
          path: '/sleep',
          builder: (context, state) => const SleepMainScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          name: 'dreams',
          path: '/dreams',
          builder: (context, state) => const DreamsScreen(),
          routes: <RouteBase>[
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'add',
              path: 'add',
              builder: (context, state) => const AddDreamScreen(),
            ),
          ],
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          name: 'settings',
          path: '/settings',
          builder: (context, state) => const SettingsMainScreen(),
          routes: <RouteBase>[
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'data',
              path: 'data',
              builder: (context, state) => const SettingsDataScreen(),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'profile',
              path: 'profile',
              builder: (context, state) => const SettingsProfileScreen(),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'email',
              path: 'email',
              builder: (context, state) => const SettingsEmailScreen(),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'password',
              path: 'password',
              builder: (context, state) => const SettingsPasswordScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: 'auth',
      path: '/auth',
      builder: (context, state) => const AuthMainScreen(),
      routes: <RouteBase>[
        GoRoute(
          name: 'login',
          path: 'login',
          builder: (context, state) => AuthLoginScreen(
            email: state.queryParameters['email'],
          ),
        ),
        GoRoute(
          name: 'register',
          path: 'register',
          builder: (context, state) => AuthRegisterScreen(
            email: state.queryParameters['email'],
          ),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const ErrorScreen(),
);
