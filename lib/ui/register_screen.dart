import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _displayName = '';
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Nom d\'utilisateur'),
                onChanged: (value) {
                  setState(() {
                    _displayName = value.trim();
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Merci d\'entrer votre nom d\'utilisateur';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Adresse mail'),
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Merci d\'entrer votre email';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _password = value.trim();
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Merci d\'entrer votre mot de passe';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await authProvider.signUp(
                          _displayName, _email, _password);
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }
                },
                child: const Text('Inscription'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
