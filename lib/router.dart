import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'providers/app_provider.dart';
import 'providers/user_provider.dart';

import 'ui/utils/navigation_bar.dart';
import 'ui/home_screen.dart';
import 'ui/analytics_screen.dart';
import 'ui/sleep_screen.dart';
import 'ui/dreams/dream_screen.dart';
import 'ui/dreams/view_screen.dart';
import 'ui/dreams/add_screen.dart';
import 'ui/dreams/edit_screen.dart';
import 'ui/settings/settings_screen.dart';
import 'ui/settings/data_screen.dart';
import 'ui/settings/profile_screen.dart';
import 'ui/settings/email_screen.dart';
import 'ui/settings/password_screen.dart';
import 'ui/user/auth_screen.dart';
import 'ui/user/login_screen.dart';
import 'ui/user/register_screen.dart';
import 'ui/user/init_screen.dart';
import 'ui/wizard/data_screen.dart';
import 'ui/wizard/welcome_screen.dart';
import 'ui/error_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: '/',
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
          redirect: (BuildContext context, GoRouterState state) {
            final appProvider =
                Provider.of<AppProvider>(context, listen: false);
            final userProvider =
                Provider.of<UserProvider>(context, listen: false);
            if (!appProvider.hasCompletedOnboarding) {
              if (userProvider.user == null) {
                return ('/auth');
              } else {
                return null;
              }
            } else {
              return ('/welcome');
            }
          },
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
          builder: (context, state) => const DreamMainScreen(),
          routes: <RouteBase>[
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'view',
              path: 'view/:id',
              builder: (context, state) => DreamDetailsScreen(
                id: state.pathParameters['id']!,
              ),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'add',
              path: 'add',
              builder: (context, state) => const DreamAddScreen(),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'edit',
              path: 'edit/:id',
              builder: (context, state) => DreamEditScreen(
                id: state.pathParameters['id']!,
              ),
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
              name: 'settingsdata',
              path: 'data',
              builder: (context, state) => const SleepDataPage(),
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
      builder: (context, state) => const UserAuthScreen(),
      routes: <RouteBase>[
        GoRoute(
          name: 'login',
          path: 'login',
          builder: (context, state) => UserLoginScreen(
            email: state.queryParameters['email'],
          ),
        ),
        GoRoute(
          name: 'register',
          path: 'register',
          builder: (context, state) => UserRegisterScreen(
            email: state.queryParameters['email'],
          ),
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: 'init',
      path: '/init',
      builder: (context, state) => const UserInitScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: 'data',
      path: '/data',
      builder: (context, state) => const WizardDataScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: 'welcome',
      path: '/welcome',
      builder: (context, state) => const WizardWelcomeScreen(),
    ),
  ],
  errorBuilder: (context, state) => const ErrorScreen(),
);
