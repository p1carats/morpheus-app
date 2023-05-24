import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../providers/user_provider.dart';
import '../providers/dream_provider.dart';
import '../providers/sleep_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final dreamProvider = Provider.of<DreamProvider>(context, listen: false);
    final sleepProvider = Provider.of<SleepProvider>(context, listen: false);
    //List of dreams
    final dreams = dreamProvider.filteredDreams;
    return Scaffold(
      appBar: AppBar(
        title: Text('Bonjour ${userProvider.user!.name} !'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Ma dernière nuit de sommeil',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Consumer<SleepProvider>(
                      builder: (context, provider, child) {
                        final sleepData = provider.sleepData;
                        if (sleepData.isEmpty) {
                          provider.fetchSleepData();
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  'Durée de sommeil',
                                  style: TextStyle(fontSize: 16),
                                ),
                                provider.getHoursOfSleep() != null
                                    ? Text(
                                        '${provider.getHoursOfSleep()}h',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : const Text(
                                        'Pas de données',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListTile(
                  leading: const Icon(Ionicons.moon_outline),
                  title: const Text(
                    'Rêves',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    Intl.plural(
                      dreams.length,
                      zero: 'Vous n\'avez pas rêvé cette nuit',
                      one: 'Vous avez fait ${dreams.length} rêve cette nuit',
                      other: 'Vous avez fait ${dreams.length} rêves cette nuit',
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => context.pushNamed('add'),
              child: const Text('Ajouter un nouveau rêve'),
            ),
          ],
        ),
      ),
    );
  }
}
