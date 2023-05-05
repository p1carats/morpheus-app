import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/auth_provider.dart';
import 'services/auth_service.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(providers: [
      Provider(create: (_) => AuthService()),
      ChangeNotifierProxyProvider<AuthService, AuthProvider>(
        create: (_) => AuthProvider(),
        update: (_, authService, authProvider) =>
            authProvider!..updateAuthService(authService),
      ),
    ], child: const Morpheus()),
  );
}
