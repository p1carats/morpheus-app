import 'dart:async';

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
        pageBuilder: (context, state) =>
            const MaterialPage(child: HomeScreen()),
        //redirect: (context, state) => Future.value('/login'),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) =>
            const MaterialPage(child: LoginScreen()),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) =>
            const MaterialPage(child: RegisterScreen()),
      ),
    ],
  );

  GoRouter get goRouter => router;
}
