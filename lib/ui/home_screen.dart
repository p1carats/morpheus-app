import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../providers/user_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context);
    int currentPageIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
      ),
      body: Center(
        child: authProvider.user == null
            ? const Text('Non connecté :(')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Connecté en tant que ${authProvider.user!.name}'),
                  ElevatedButton(
                    onPressed: () async {
                      await authProvider.signOut();
                    },
                    child: const Text('Déconnexion'),
                  ),
                ],
              ),
      ),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          onPressed: () => context.goNamed('login'),
          tooltip: 'Connexion',
          heroTag: 'loginBtn',
          child: const Icon(Ionicons.log_in_outline),
        ),
      ]),
    );
  }
}
