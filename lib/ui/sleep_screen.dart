import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SleepMainScreen extends StatefulWidget {
  const SleepMainScreen({Key? key}) : super(key: key);

  @override
  State<SleepMainScreen> createState() => _SleepMainScreenState();
}

class _SleepMainScreenState extends State<SleepMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sommeil'),
      ),
      body: const Placeholder(),
    );
  }
}
