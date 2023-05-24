import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../providers/user_provider.dart';

class UserAuthScreen extends StatefulWidget {
  const UserAuthScreen({Key? key}) : super(key: key);

  @override
  State<UserAuthScreen> createState() => _UserAuthScreenState();
}

class _UserAuthScreenState extends State<UserAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var isEmailRegistered =
          await Provider.of<UserProvider>(context, listen: false)
              .isEmailRegistered(_email);
      if (context.mounted) {
        isEmailRegistered
            ? context.pushNamed('login', queryParameters: {'email': _email})
            : context.pushNamed('register', queryParameters: {'email': _email});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenue sur Morpheus !'),
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
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une adresse mail !';
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Adresse email invalide !';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
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
                  child: const Text('Continuer avec mon adresse mail'),
                ),
                const SizedBox(height: 15),
                TextButton.icon(
                  icon: const Icon(Ionicons.logo_google),
                  label: const Text('Continuer avec mon compte Google'),
                  onPressed: () async {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
