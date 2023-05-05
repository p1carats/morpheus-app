import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

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
                  Text(
                      'Connecté en tant que ${authProvider.user!.displayName}'),
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
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          tooltip: 'Connexion',
          heroTag: 'loginBtn',
          child: const Icon(Icons.login),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
          tooltip: 'Inscription',
          heroTag: 'registerBtn',
          child: const Icon(Icons.app_registration),
        ),
      ]),
    );
  }
}
