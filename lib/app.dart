import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'providers/theme_provider.dart';
import 'router.dart';

class Morpheus extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const Morpheus({Key? key, required this.sharedPreferences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    ThemeMode themeMode;
    switch (themeProvider.themeType) {
      case ThemeType.light:
        themeMode = ThemeMode.light;
        break;
      case ThemeType.dark:
        themeMode = ThemeMode.dark;
        break;
      case ThemeType.system:
      default:
        themeMode = ThemeMode.system;
    }

    return MaterialApp.router(
      title: 'Morpheus',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Montserrat',
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Montserrat',
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerConfig: router,
    );
  }
}
