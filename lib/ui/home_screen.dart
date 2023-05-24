import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Bonjour ${userProvider.user!.name} !'),
              background: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/banner.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Card(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Ma dernière nuit de sommeil',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      //Display the sleep data of the last night
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
              //Card with the number of dreams
              Card(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: const [
                          Text(
                            'Mes rêves ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Icon(Ionicons.moon_outline, size: 20),
                          SizedBox(height: 60),
                        ],
                      ),
                      Text(
                        'J\'ai fait ${dreams.length} rêves aujourd\'hui',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
