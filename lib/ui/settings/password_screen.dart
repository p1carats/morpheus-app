import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPasswordScreen extends StatefulWidget {
  const SettingsPasswordScreen({Key? key}) : super(key: key);

  @override
  State<SettingsPasswordScreen> createState() => _SettingsPasswordScreenState();
}

class _SettingsPasswordScreenState extends State<SettingsPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier mon mot de passe'),
      ),
      body: const Placeholder(),
    );
  }
}
