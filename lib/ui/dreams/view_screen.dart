//Create page for see all details of a dream and edit it

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

class DreamDetailsScreen extends StatefulWidget {
  const DreamDetailsScreen({Key? key}) : super(key: key);

  @override
  State<DreamDetailsScreen> createState() => _DreamDetailsScreenState();
}

class _DreamDetailsScreenState extends State<DreamDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The title is the dream's title
        title: const Text('Détails du rêve'),
      ),
      body: const Placeholder(),
    );
  }
}
