import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WizardWelcomeScreen extends StatefulWidget {
  const WizardWelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WizardWelcomeScreen> createState() => _WizardWelcomeScreenState();
}

class _WizardWelcomeScreenState extends State<WizardWelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenue !'),
      ),
      body: const Placeholder(),
    );
  }
}
