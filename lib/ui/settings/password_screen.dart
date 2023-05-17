import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

class SettingsPasswordScreen extends StatefulWidget {
  const SettingsPasswordScreen({Key? key}) : super(key: key);

  @override
  State<SettingsPasswordScreen> createState() => _SettingsPasswordScreenState();
}

class _SettingsPasswordScreenState extends State<SettingsPasswordScreen> {
  final _newpasswordController = TextEditingController();
  final _oldpasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un mot de passe.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Ionicons.arrow_back_outline),
          onPressed: () => context.pop(),
        ),
        title: const Text('Modifier mon mot de passe'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              obscureText: true,
              controller: _oldpasswordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ancien Mot de passe',
              ),
              validator: _validatePassword,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              obscureText: true,
              controller: _newpasswordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nouveau Mot de passe',
              ),
              validator: _validatePassword,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () async {
                final String oldPassword = _oldpasswordController.text.trim();
                final String newPassword = _newpasswordController.text.trim();

                if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
                  try {
                    final User? user = _auth.currentUser;
                    final credential = EmailAuthProvider.credential(
                        email: user!.email!, password: oldPassword);
                    await user.reauthenticateWithCredential(credential);
                    await user.updatePassword(newPassword);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Mot de passe modifié !'),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }
                    // Envoyer un email pour confirmer le nouveau mot de passe
                    await user.sendEmailVerification();
                  } catch (err) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(err.toString()),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Veuillez remplir tous les champs.'),
                      backgroundColor: Colors.red,
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
