import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

class ForgottenScreen extends StatefulWidget {
  const ForgottenScreen({Key? key}) : super(key: key);

  @override
  _ForgottenScreenState createState() => _ForgottenScreenState();
}

class _ForgottenScreenState extends State<ForgottenScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Ionicons.arrow_back_outline),
          onPressed: () => context.pop(),
        ),
        title: const Text('Mot de passe oublié'),
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
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: _email);
                          showDialog(context: context, builder: (context) => AlertDialog(
                            title: const Text('Email envoyé'),
                            content: Text('Un email de réinitialisation de mot de passe a été envoyé à l\'adresse $_email'),
                            actions: [
                              TextButton(
                                onPressed: () => context.pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          ));
                        // Password reset email sent successfully
                        // You can show a success message or navigate to a different screen
                      } catch (e) {
                        // Handle error - display an error message or perform any necessary actions
                      }
                    }
                  },
                  child: const Text('Réinitialiser le mot de passe'),
                ),
                const SizedBox(height: 10),
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
