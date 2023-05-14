import 'package:flutter/material.dart';

import 'router.dart';

class Morpheus extends StatelessWidget {
  Morpheus({Key? key}) : super(key: key);
  final _routerDelegate = AppRouterDelegate();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Morpheus',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
      ),
      routerDelegate: _routerDelegate.goRouter.routerDelegate,
      routeInformationParser: _routerDelegate.goRouter.routeInformationParser,
    );
  }
}
