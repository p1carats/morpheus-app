import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ionicons/ionicons.dart';

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
    final user = userAuthProvider.user!;
    Provider.of<DreamProvider>(context, listen: false).listenToDreams(user.uid);
  }

  Future<void> _refreshDreams() async {
    final userAuthProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userAuthProvider.user!;
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
          Provider.of<DreamProvider>(context).filteredDreams.isNotEmpty
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
            if (provider.filteredDreams.isEmpty) {
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
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Wrap(
                          spacing: 10,
                          alignment: WrapAlignment.start,
                          children: [
                            _buildChip('Tous', 'all'),
                            _buildChip('Rêves', 'dream'),
                            _buildChip('Cauchemars', 'nightmare'),
                            _buildChip('Rêves lucides', 'lucid'),
                            _buildChip('Rêves récurrents', 'recurrent'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    icon: Icon(Provider.of<DreamProvider>(context)
                            .isOrderedChronologically
                        ? Icons.arrow_upward
                        : Icons.arrow_downward),
                    label: Text(Provider.of<DreamProvider>(context)
                            .isOrderedChronologically
                        ? 'Du plus récent au plus ancien'
                        : 'Du plus ancien au plus récent'),
                    onPressed: () =>
                        Provider.of<DreamProvider>(context, listen: false)
                            .toggleOrder(),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ListView.builder(
                        itemCount: provider.filteredDreams.length,
                        itemBuilder: (context, index) {
                          DreamModel dream = provider.filteredDreams[index];
                          final String id = dream.id!;
                          return Card(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                onTap: () => context.pushNamed('view',
                                    pathParameters: {'id': id}),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    Text(
                                      DateFormat('MMM', 'fr_FR')
                                          .format(dream.date),
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
