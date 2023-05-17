import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

class SettingsEmailScreen extends StatefulWidget {
  const SettingsEmailScreen({Key? key}) : super(key: key);

  @override
  State<SettingsEmailScreen> createState() => _SettingsEmailScreenState();
}

class _SettingsEmailScreenState extends State<SettingsEmailScreen> {
  final _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Ionicons.arrow_back_outline),
          onPressed: () => context.pop(),
        ),
        title: const Text('Modifier mon adresse mail'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nouvelle adresse mail',
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mot de passe',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                try {
                  _auth.currentUser!.updateEmail(_emailController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Adresse mail modifiée !'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                  //send mail to confirm new email
                  _auth.currentUser!.sendEmailVerification();
                } catch (err) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(err.toString()),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              },
              child: const Text('Enregistrer'),
            ),
          ),
        ],
      ),
    );
  }
}
