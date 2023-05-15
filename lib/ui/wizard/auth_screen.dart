import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WizardAuthScreen extends StatefulWidget {
  const WizardAuthScreen({Key? key}) : super(key: key);

  @override
  State<WizardAuthScreen> createState() => _WizardAuthScreenState();
}

class _WizardAuthScreenState extends State<WizardAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adresse mail'),
      ),
      body: const Placeholder(),
    );
  }
}
