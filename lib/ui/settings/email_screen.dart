import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsEmailScreen extends StatefulWidget {
  const SettingsEmailScreen({Key? key}) : super(key: key);

  @override
  State<SettingsEmailScreen> createState() => _SettingsEmailScreenState();
}

class _SettingsEmailScreenState extends State<SettingsEmailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier mon adresse mail'),
      ),
      body: const Placeholder(),
    );
  }
}
