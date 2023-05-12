import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'ui/home_screen.dart';
import 'ui/login_screen.dart';
import 'ui/register_screen.dart';

class AppRouterDelegate {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => MaterialPage(child: HomeScreen()),
        redirect: (_) => '/login',
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => MaterialPage(child: LoginScreen()),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => MaterialPage(child: RegisterScreen()),
      ),
    ],
  );

  GoRouter get goRouter => router;
}
