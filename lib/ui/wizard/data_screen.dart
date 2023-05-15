import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WizardDataScreen extends StatefulWidget {
  const WizardDataScreen({Key? key}) : super(key: key);

  @override
  State<WizardDataScreen> createState() => _WizardDataScreenState();
}

class _WizardDataScreenState extends State<WizardDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Récupération des données'),
      ),
      body: const Placeholder(),
    );
  }
}
