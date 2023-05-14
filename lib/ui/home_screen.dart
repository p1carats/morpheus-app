import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context);

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
                      //print la phrase suivante : "Connecté en tant que ${displayName}"
                      'Connecté en tant que ${authProvider.user!.name}'),
                  if (FirebaseAuth.instance.currentUser!.emailVerified)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.redAccent,
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.warning, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Email not verified',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
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
