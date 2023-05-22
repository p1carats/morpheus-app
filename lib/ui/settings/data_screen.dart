import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../providers/sleep_provider.dart';

class SleepDataPage extends StatefulWidget {
  const SleepDataPage({Key? key}) : super(key: key);

  @override
  _SleepDataPageState createState() => _SleepDataPageState();
}

class _SleepDataPageState extends State<SleepDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Ionicons.arrow_back_outline),
          onPressed: () => context.pop(),
        ),
        title: const Text('Gestion des données'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Provider.of<SleepProvider>(context, listen: false)
                  .fetchSleepData();
            },
            child: const Text('Autoriser l\'accès aux données de sommeil'),
          ),
          Expanded(
            child: Consumer<SleepProvider>(
              builder: (context, sleepProvider, child) {
                return ListView.builder(
                  itemCount: sleepProvider.sleepData.length,
                  itemBuilder: (context, index) {
                    final sleep = sleepProvider.sleepData[index];
                    return ListTile(
                      title: Text('${sleep.value} minutes'),
                      subtitle: Text('${sleep.dateFrom} - ${sleep.dateTo}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
