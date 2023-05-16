import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'ui/auth/auth_screen.dart';
import 'ui/auth/login_screen.dart';
import 'ui/auth/register_screen.dart';

import 'ui/wizard/welcome_screen.dart';
import 'ui/utils/navigation_bar.dart';
import 'ui/error_screen.dart';
import 'ui/home_screen.dart';
import 'ui/sleep_screen.dart';
import 'ui/dreams_screen.dart';
import 'ui/add_dream_screen.dart';

import 'ui/settings/settings_screen.dart';
import 'ui/settings/data_screen.dart';
import 'ui/settings/profile_screen.dart';
import 'ui/settings/email_screen.dart';
import 'ui/settings/password_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/auth',
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
              name: 'add',
              path: 'add',
              builder: (context, state) => const AddDreamScreen(),
            ),
          ],
        ),
        GoRoute(
          name: 'settings',
          path: '/settings',
          builder: (context, state) => const SettingsMainScreen(),
          routes: <RouteBase>[
            GoRoute(
              name: 'data',
              path: 'data',
              builder: (context, state) => const SettingsDataScreen(),
            ),
            GoRoute(
              name: 'profile',
              path: 'profile',
              builder: (context, state) => const SettingsProfileScreen(),
            ),
            GoRoute(
              name: 'email',
              path: 'email',
              builder: (context, state) => const SettingsEmailScreen(),
            ),
            GoRoute(
              name: 'password',
              path: 'password',
              builder: (context, state) => const SettingsPasswordScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      name: 'auth',
      path: '/auth',
      builder: (context, state) => const AuthMainScreen(),
      routes: <RouteBase>[
        GoRoute(
          name: 'login',
          path: 'login',
          builder: (context, state) => const AuthLoginScreen(),
        ),
        GoRoute(
          name: 'register',
          path: 'register',
          builder: (context, state) => const AuthRegisterScreen(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const ErrorScreen(),
);
