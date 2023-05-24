import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '/providers/user_provider.dart';

class SettingsEmailScreen extends StatefulWidget {
  const SettingsEmailScreen({Key? key}) : super(key: key);

  @override
  State<SettingsEmailScreen> createState() => _SettingsEmailScreenState();
}

class _SettingsEmailScreenState extends State<SettingsEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _email = '';
  String _password = '';

  void _submit() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);
      try {
        await Provider.of<UserProvider>(context, listen: false)
            .updateEmail(userProvider.user!.uid, _email, _password);
        if (context.mounted) context.goNamed('settings');
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentEmail =
        Provider.of<UserProvider>(context, listen: false).user!.email;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Ionicons.arrow_back_outline),
          onPressed: () => context.pop(),
        ),
        title: const Text('Modifier mon adresse mail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 5),
              Text(
                'Votre adresse mail actuelle : $currentEmail',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Adresse mail',
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
                  _email = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
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
                  _password = value!;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => _submit(),
                      child: const Text('Modifier mon adresse mail'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
