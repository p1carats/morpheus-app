import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../models/dream_model.dart';

import '../../providers/user_provider.dart';
import '../../providers/dream_provider.dart';

class DreamDetailsScreen extends StatefulWidget {
  const DreamDetailsScreen({Key? key, required this.id}) : super(key: key);
  final String? id;

  @override
  State<DreamDetailsScreen> createState() => _DreamDetailsScreenState();
}

class _DreamDetailsScreenState extends State<DreamDetailsScreen> {
  late Future<DreamModel?> _dreamFuture;

  @override
  void initState() {
    super.initState();
    final uid = Provider.of<UserProvider>(context, listen: false).user!.uid;
    _dreamFuture = Provider.of<DreamProvider>(context, listen: false)
        .getDream(uid, widget.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du rêve'),
        leading: IconButton(
          icon: const Icon(Ionicons.arrow_back_outline),
          onPressed: () => context.pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Ionicons.create_outline),
            tooltip: 'Modifier',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Ionicons.trash_outline),
            tooltip: 'Supprimer',
            onPressed: () => {},
          ),
        ],
      ),
      body: FutureBuilder<DreamModel?>(
        future: _dreamFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            DreamModel? dream = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Title: ${dream?.title}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description: ${dream?.description}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Date: ${dream?.date}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Type: ${dream?.type}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Rating: ${dream?.rating}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Is Lucid: ${dream!.isLucid ? "Oui" : "Non"}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
