import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ionicons/ionicons.dart';

import '../../models/user_model.dart';
import '../../models/dream_model.dart';

import '../../providers/user_provider.dart';
import '../../providers/dream_provider.dart';

class DreamMainScreen extends StatefulWidget {
  const DreamMainScreen({Key? key}) : super(key: key);

  @override
  State<DreamMainScreen> createState() => _DreamMainScreenState();
}

class _DreamMainScreenState extends State<DreamMainScreen> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR', null);
    final userAuthProvider = Provider.of<UserProvider>(context, listen: false);
    final UserModel user = userAuthProvider.user!;
    Provider.of<DreamProvider>(context, listen: false).listenToDreams(user.uid);
  }

  Future<void> _refreshDreams() async {
    final userAuthProvider = Provider.of<UserProvider>(context, listen: false);
    final UserModel user = userAuthProvider.user!;
    Provider.of<DreamProvider>(context, listen: false).listenToDreams(user.uid);
  }

  Widget _buildChip(String label, String filterType) {
    final provider = Provider.of<DreamProvider>(context, listen: false);

    return ChoiceChip(
      label: Text(label),
      selected: provider.filterType == filterType,
      onSelected: (bool selected) {
        provider.setFilter(filterType);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rêves'),
        actions: <Widget>[
          Provider.of<DreamProvider>(context).dreams.isNotEmpty
              ? TextButton.icon(
                  icon: const Icon(Ionicons.add_outline),
                  label: const Text('Nouveau rêve'),
                  onPressed: () => context.pushNamed('add'),
                )
              : Container(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDreams,
        child: Consumer<DreamProvider>(
          builder: (context, provider, child) {
            if (provider.dreams.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Aucun rêve n\'a été enregistré.'),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () => context.pushNamed('add'),
                      child: const Text('Ajouter mon premier rêve'),
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 15),
                        _buildChip('Tous', 'all'),
                        const SizedBox(width: 10),
                        _buildChip('Rêves', 'dream'),
                        const SizedBox(width: 10),
                        _buildChip('Cauchemars', 'nightmare'),
                        const SizedBox(width: 10),
                        _buildChip('Rêves lucides', 'lucid'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.dreams.length,
                      itemBuilder: (context, index) {
                        DreamModel dream = provider.dreams[index];
                        final String id = dream.id!;
                        return Card(
                          child: ListTile(
                            onTap: () => context
                                .pushNamed('view', pathParameters: {'id': id}),
                            title: Text(
                              dream.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              dream.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  dream.date.day.toString(),
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                Text(
                                  DateFormat('MMM', 'fr_FR').format(dream.date),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
