import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/app_provider.dart';
import 'providers/user_provider.dart';
import 'providers/sleep_provider.dart';
import 'providers/dream_provider.dart';

import 'firebase_options.dart';
import 'app.dart';

void main() async {
  // Ensure that all widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Run app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(
            create: (_) => UserProvider()..checkAuthentication()),
        ChangeNotifierProvider(create: (_) => SleepProvider()),
        ChangeNotifierProvider(create: (_) => DreamProvider()),
      ],
      child: const Morpheus(),
    ),
  );
}
