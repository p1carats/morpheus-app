import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

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
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Ionicons.add_outline),
            label: const Text('Nouveau rêve'),
            onPressed: () => context.push('/add'),
            //onPressed: () => context.push('/add'),
          ),
        ],
      ),
      body: const Placeholder(),
    );
  }
}
