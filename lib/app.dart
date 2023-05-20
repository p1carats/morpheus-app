import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_provider.dart';
import 'router.dart';

class Morpheus extends StatelessWidget {
  const Morpheus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<AppProvider>(context);

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
