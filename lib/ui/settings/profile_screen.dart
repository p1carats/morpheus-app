import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({Key? key}) : super(key: key);

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
      ),
      body: const Placeholder(),
    );
  }
}
