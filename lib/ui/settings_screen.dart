import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../providers/user_auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context);

    Widget contentWidget = Container(); // Initial value

    if (authProvider.user != null) {
      if (!authProvider.user!.isEmailVerified) {
        contentWidget = Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.redAccent,
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Ionicons.warning_outline, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Adresse mail non vérifiée !',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      } else if (authProvider.user!.isEmailVerified) {
        contentWidget = Column(
          children: [
            Text('Connecté en tant que ${authProvider.user!.name}'),
            ElevatedButton(
              child: const Text('Déconnexion'),
              onPressed: () async {
                context.go('/');
                await authProvider.signOut();
              },
            ),
          ],
        );
      }
    } else {
      contentWidget = ElevatedButton(
        onPressed: () => context.goNamed('login'),
        child: const Text('Connexion'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Réglages'),
      ),
      body: Center(
        child: Column(
          children: [
            contentWidget,
          ],
        ),
      ),
    );
  }
}
