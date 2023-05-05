import 'package:flutter/material.dart';

import 'ui/home_screen.dart';
import 'ui/login_screen.dart';
import 'ui/register_screen.dart';

class Morpheus extends StatelessWidget {
  const Morpheus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Morpheus',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
