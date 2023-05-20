import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../models/dream_model.dart';

import '../../providers/user_provider.dart';
import '../../providers/dream_provider.dart';

class DreamDetailsScreen extends StatefulWidget {
  const DreamDetailsScreen({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<DreamDetailsScreen> createState() => _DreamDetailsScreenState();
}

class _DreamDetailsScreenState extends State<DreamDetailsScreen> {
  late Future<DreamModel?> _dreamFuture;

  final Map<String, IconData> dreamType = {
    'dream': Ionicons.sunny_outline,
    'nightmare': Ionicons.thunderstorm_outline,
  };

  @override
  void initState() {
    super.initState();
    final uid = Provider.of<UserProvider>(context, listen: false).user!.uid;
    _dreamFuture = Provider.of<DreamProvider>(context, listen: false)
        .getDream(uid, widget.id);
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
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Suppression du rêve'),
                  content: const Text(
                      'Êtes-vous sûr de vouloir supprimer ce rêve ? Cette action est irréversible.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () async {
                        String user =
                            Provider.of<UserProvider>(context, listen: false)
                                .user!
                                .uid;
                        await Provider.of<DreamProvider>(context, listen: false)
                            .deleteDream(user, widget.id);
                        if (context.mounted) context.pop();
                        if (context.mounted) context.pop();
                      },
                      child: const Text('Supprimer'),
                    ),
                  ],
                ),
              );
            },
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
                  Row(
                    children: [
                      Icon(
                        dreamType[dream!.type],
                        color: Theme.of(context).colorScheme.secondary,
                        //size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        dream.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat('dd/MM/yyyy').format(dream.date),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    dream.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Note : ${dream.rating.toString()}/5',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Icon(
                            dream.isControllable
                                ? Ionicons.checkmark_outline
                                : Ionicons.close_outline,
                            //size: 16,
                          ),
                          Text(
                            'Rêve lucide',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            dream.isControllable
                                ? Ionicons.checkmark_outline
                                : Ionicons.close_outline,
                            //size: 16,
                          ),
                          Text(
                            'Rêve contrôlable',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ],
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
