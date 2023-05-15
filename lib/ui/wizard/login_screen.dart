import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../providers/user_auth_provider.dart';

class WizardLoginScreen extends StatefulWidget {
  const WizardLoginScreen({Key? key}) : super(key: key);

  @override
  _WizardLoginScreenState createState() => _WizardLoginScreenState();
}

class _WizardLoginScreenState extends State<WizardLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await Provider.of<UserAuthProvider>(context, listen: false)
            .signIn(_email, _password);
        context.goNamed('home');
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
        title: const Text('Connexion'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Adresse mail',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Ionicons.mail_outline),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Adresse email incorrecte !';
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
                    if (value!.isEmpty || value.length < 7) {
                      return 'Password must be at least 7 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _submit,
                  child: const Text('Connexion'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  child: const Text('Mot de passe oublié ?'),
                  onPressed: () => context.go('/register'),
                ),
                TextButton(
                  child: const Text('Pas encore de compte ?'),
                  onPressed: () => context.go('/register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
