import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

class SettingsNameScreen extends StatefulWidget {
  const SettingsNameScreen({Key? key}) : super(key: key);

  @override
  State<SettingsNameScreen> createState() => _SettingsNameScreenState();
}

class _SettingsNameScreenState extends State<SettingsNameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _nameController.text = _auth.currentUser!.displayName ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Ionicons.arrow_back_outline),
          onPressed: () => context.pop(),
        ),
        title: const Text('Modifier mon nom'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nom',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez saisir votre nom';
              }
              return null;
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          try {
            _auth.currentUser!.updateDisplayName(_nameController.text);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Nom modifié avec succès !'),
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withGreen(200),
              ),
            );
            _auth.currentUser!.reload();
            FirebaseAuth.instance.userChanges().listen((User? user) {
              if (user == null) {
                context.go('/auth');
              }
            });
          } catch (err) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(err.toString()),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: const Icon(Ionicons.checkmark_outline),
      ),
    );
  }
}
