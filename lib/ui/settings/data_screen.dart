import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsDataScreen extends StatefulWidget {
  const SettingsDataScreen({Key? key}) : super(key: key);

  @override
  State<SettingsDataScreen> createState() => _SettingsDataScreenState();
}

class _SettingsDataScreenState extends State<SettingsDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Données de santé'),
      ),
      body: const Placeholder(),
    );
  }
}
