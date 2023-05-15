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
                            Icon(Ionicons.warning_outline, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Adresse mail non vérifiée !',
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
          onPressed: () => context.goNamed('login'),
          tooltip: 'Connexion',
          heroTag: 'loginBtn',
          child: const Icon(Ionicons.log_in_outline),
        ),
      ]),
    );
  }
}
