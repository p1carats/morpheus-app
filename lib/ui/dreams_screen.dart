import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DreamsScreen extends StatefulWidget {
  const DreamsScreen({Key? key}) : super(key: key);

  @override
  State<DreamsScreen> createState() => _DreamsScreenState();
}

class _DreamsScreenState extends State<DreamsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rêves'),
      ),
      body: const Placeholder(),
    );
  }
}
