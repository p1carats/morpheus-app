import 'package:flutter/material.dart';
import 'package:morpheus/services/dream_data_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'providers/user_auth_provider.dart';
import 'providers/user_data_provider.dart';
import 'providers/dream_data_provider.dart';

import 'services/user_auth_service.dart';
import 'services/user_data_service.dart';
import 'services/dream_data_service.dart';

import 'firebase_options.dart';
import 'app.dart';

void main() async {
  // Ensure that all widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Shared Preferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Run app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserAuthProvider>(
          create: (_) => UserAuthProvider(
              userAuthService:
                  UserAuthService(userDataService: UserDataService())),
        ),
        ChangeNotifierProvider<UserDataProvider>(
          create: (_) => UserDataProvider(userDataService: UserDataService()),
        ),
        ChangeNotifierProvider<DreamDataProvider>(
          create: (_) =>
              DreamDataProvider(dreamDataService: DreamDataService()),
        ),
      ],
      child: Morpheus(sharedPreferences: prefs),
    ),
  );
}
