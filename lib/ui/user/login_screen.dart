import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../providers/user_provider.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({Key? key, required this.email}) : super(key: key);
  final String? email;

  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submit() async {
    _email = widget.email ?? '';
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await Provider.of<UserProvider>(context, listen: false)
            .signIn(_email, _password);
        if (context.mounted) context.go('/');
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
                Text('Connecté⸱e en tant que ${widget.email}'),
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
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Réinitialisation du mot de passe',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Êtes-vous sûr de vouloir réinitialiser votre mot de passe ? Un lien de confirmation sera envoyé à l\'adresse mail ${widget.email}.',
                              style: Theme.of(context).textTheme.titleMedium,
                              //textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                TextButton(
                                  child: const Text('Oui'),
                                  onPressed: () async {
                                    try {
                                      await Provider.of<UserProvider>(context,
                                              listen: false)
                                          .resetPassword(widget.email!);
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                                'Un mail de confirmation vous a été envoyé. Pensez à vérifier vos spams !'),
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        );
                                      }
                                    } catch (err) {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(err.toString()),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                TextButton(
                                  child: const Text('Annuler'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  child: const Text('Mot de passe oublié ?'),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
