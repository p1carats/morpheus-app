import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:morpheus/providers/user/data_provider.dart';
import 'package:provider/provider.dart';

class SettingsPasswordScreen extends StatefulWidget {
  const SettingsPasswordScreen({Key? key}) : super(key: key);

  @override
  State<SettingsPasswordScreen> createState() => _SettingsPasswordScreenState();
}

class _SettingsPasswordScreenState extends State<SettingsPasswordScreen> {
  final _newpasswordController = TextEditingController();
  final _oldpasswordController = TextEditingController();

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
                labelText: 'Ancien mot de passe',
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
                labelText: 'Nouveau mot de passe',
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
                    if (context.mounted) {
                      context
                          .read<UserDataProvider>()
                          .reauthenticate(oldPassword);
                      context
                          .read<UserDataProvider>()
                          .changePassword(_newpasswordController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Mot de passe modifié !'),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                      );

                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Déconnexion'),
                              content:
                                  const Text('Vous allez être déconnecté.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<UserDataProvider>()
                                        .disconnect();
                                    context.go('/auth');
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          });
                    }
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
                    SnackBar(
                      content: const Text('Veuillez remplir tous les champs.'),
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
