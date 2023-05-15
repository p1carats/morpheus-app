import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'router.dart';

class Morpheus extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const Morpheus({Key? key, required this.sharedPreferences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Morpheus',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Montserrat',
      ),
      routerConfig: router,
    );
  }
}
