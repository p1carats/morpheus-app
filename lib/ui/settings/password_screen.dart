import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../providers/user_provider.dart';

class SettingsPasswordScreen extends StatefulWidget {
  const SettingsPasswordScreen({Key? key}) : super(key: key);

  @override
  State<SettingsPasswordScreen> createState() => _SettingsPasswordScreenState();
}

class _SettingsPasswordScreenState extends State<SettingsPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _oldPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';

  void _submit() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await userProvider.changePassword(_oldPassword, _newPassword);
        await userProvider.signOut();
        if (context.mounted) context.goNamed('auth');
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Ancien mot de passe',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Ionicons.lock_closed_outline),
                ),
                validator: (value) {
                  if (value!.isEmpty ||
                      value.length < 7 ||
                      !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value) ||
                      !RegExp(r'\d').hasMatch(value)) {
                    return 'Le mot de passe doit contenir au moins 7 caractères, et contenir au moins un chiffre et un symbole.';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _oldPassword = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nouveau mot de passe',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Ionicons.lock_closed_outline),
                ),
                validator: (value) {
                  if (value!.isEmpty ||
                      value.length < 7 ||
                      !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value) ||
                      !RegExp(r'\d').hasMatch(value)) {
                    return 'Le mot de passe doit contenir au moins 7 caractères, et contenir au moins un chiffre et un symbole.';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _newPassword = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Ionicons.lock_closed_outline),
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 7) {
                    return 'Le mot de passe doit contenir au moins 7 caractères.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _confirmPassword = value!;
                },
              ),
              const SizedBox(height: 30),
              const Text(
                  'Par mesure de sécurité, vous serez déconnecté⸱e à l\'issue du changement de votre mot de passe.'),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () => _submit(),
                child: const Text('Changer mon mot de passe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
