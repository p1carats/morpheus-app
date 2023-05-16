import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../providers/user_auth_provider.dart';
import 'forgotten_screen.dart';

class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({Key? key, required this.email}) : super(key: key);
  final String? email;

  @override
  _AuthLoginScreenState createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submit() async {
    _email = widget.email ?? '';
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await Provider.of<UserAuthProvider>(context, listen: false)
            .signIn(_email, _password);
        context.go('/');
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err.toString()),
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
                Text('Connecté en tant que ${widget.email}'),
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
                      return 'Le mot de passe doit contenir au moins 7 caractères.';
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
                  onPressed: () => showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    context: context,
                    builder: (context) => const ForgottenScreen(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
