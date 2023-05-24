import 'package:flutter/material.dart';
import 'package:morpheus/providers/sleep_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../models/dream_model.dart';

import '../providers/dream_provider.dart';

class AnalyticsMainScreen extends StatefulWidget {
  const AnalyticsMainScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsMainScreen> createState() => _AnalyticsMainScreenState();
}

class _AnalyticsMainScreenState extends State<AnalyticsMainScreen> {
  late String _selectedDuration;
  late int totalDreamsLastWeek;
  late int totalDreamsLastMonth;
  late int totalNightmaresLastWeek;
  late int totalNightmaresLastMonth;
  late double dreamToNightmareRatioLastWeek;
  late double dreamToNightmareRatioLastMonth;
  late int totalRecurringDreamsLastWeek;
  late int totalRecurringDreamsLastMonth;
  late int totalLucidDreamsLastWeek;
  late int totalLucidDreamsLastMonth;
  late int lucidDreamsPercentageLastWeek;
  late int lucidDreamsPercentageLastMonth;
  late int totalControllableDreamsLastWeek;
  late int totalControllableDreamsLastMonth;

  @override
  void initState() {
    super.initState();
    _selectedDuration = 'month';
    computeStats();
  }

  void computeStats() {
    final provider = Provider.of<DreamProvider>(context, listen: false);

    totalDreamsLastWeek = provider.filteredDreams
        .where((dream) => dream.date
            .isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .length;
    totalDreamsLastMonth = provider.filteredDreams
        .where((dream) => dream.date
            .isAfter(DateTime.now().subtract(const Duration(days: 30))))
        .length;

    totalNightmaresLastWeek = provider.filteredDreams
        .where((dream) =>
            dream.date
                .isAfter(DateTime.now().subtract(const Duration(days: 7))) &&
            dream.type == DreamType.nightmare)
        .length;
    totalNightmaresLastMonth = provider.filteredDreams
        .where((dream) =>
            dream.date
                .isAfter(DateTime.now().subtract(const Duration(days: 30))) &&
            dream.type == DreamType.nightmare)
        .length;

    dreamToNightmareRatioLastWeek =
        provider.getDreamNightmareRatio(const Duration(days: 7));
    dreamToNightmareRatioLastMonth =
        provider.getDreamNightmareRatio(const Duration(days: 30));

    totalRecurringDreamsLastWeek = provider.filteredDreams
        .where((dream) =>
            dream.date
                .isAfter(DateTime.now().subtract(const Duration(days: 7))) &&
            dream.isRecurrent)
        .length;
    totalRecurringDreamsLastMonth = provider.filteredDreams
        .where((dream) =>
            dream.date
                .isAfter(DateTime.now().subtract(const Duration(days: 30))) &&
            dream.isRecurrent)
        .length;

    totalLucidDreamsLastWeek = provider.filteredDreams
        .where((dream) =>
            dream.date
                .isAfter(DateTime.now().subtract(const Duration(days: 7))) &&
            dream.isLucid)
        .length;
    totalLucidDreamsLastMonth = provider.filteredDreams
        .where((dream) =>
            dream.date
                .isAfter(DateTime.now().subtract(const Duration(days: 30))) &&
            dream.isLucid)
        .length;

    lucidDreamsPercentageLastWeek =
        (provider.getLucidDreamPercentage(const Duration(days: 7)) * 100)
            .round();
    lucidDreamsPercentageLastMonth =
        (provider.getLucidDreamPercentage(const Duration(days: 30)) * 100)
            .round();

    totalControllableDreamsLastWeek = provider.filteredDreams
        .where((dream) =>
            dream.date
                .isAfter(DateTime.now().subtract(const Duration(days: 7))) &&
            dream.isControllable)
        .length;
    totalControllableDreamsLastMonth = provider.filteredDreams
        .where((dream) =>
            dream.date
                .isAfter(DateTime.now().subtract(const Duration(days: 30))) &&
            dream.isControllable)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final sleepProvider = Provider.of<SleepProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              SegmentedButton<String>(
                segments: const <ButtonSegment<String>>[
                  ButtonSegment<String>(
                    value: 'week',
                    label: Text('7 derniers jours'),
                    icon: Icon(Icons.calendar_view_week),
                  ),
                  ButtonSegment<String>(
                    value: 'month',
                    label: Text('30 derniers jours'),
                    icon: Icon(Ionicons.calendar_outline),
                  ),
                ],
                showSelectedIcon: false,
                selected: <String>{_selectedDuration},
                onSelectionChanged: (Set<String> value) {
                  setState(() {
                    _selectedDuration = value.first;
                    computeStats();
                  });
                },
              ),
              const SizedBox(height: 30),
              StreamBuilder<bool>(
                stream: Stream.periodic(const Duration(seconds: 1),
                        (index) async => await sleepProvider.isAuthorized())
                    .asyncMap((event) async => await event),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    bool isAuthorized = snapshot.data!;
                    if (!isAuthorized) {
                      return Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            //height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Text(
                                  'L\'accès aux données de sommeil est désactivé.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Les statistiques liées à celles-ci ne seront donc pas affichées.',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  // If isAuthorized is true or the future hasn't completed, return an empty container
                  return Container();
                },
              ),
              const SizedBox(height: 30),
              if (_selectedDuration == 'month') ...[
                Text(
                  Intl.plural(
                    totalDreamsLastMonth,
                    zero: 'Aucun rêve enregistré ce mois-ci',
                    one: '$totalDreamsLastMonth rêve enregistré ce mois-ci',
                    other: '$totalDreamsLastMonth rêves enregistrés ce mois-ci',
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                ListTile(
                  leading: const Icon(Ionicons.repeat_outline),
                  title: Text(
                    Intl.plural(
                      totalRecurringDreamsLastMonth,
                      zero: 'Aucun rêve récurrent',
                      one: '$totalRecurringDreamsLastMonth rêve récurrent',
                      other: '$totalRecurringDreamsLastMonth rêves récurrents',
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Ionicons.thunderstorm_outline),
                  title: Text(
                    Intl.plural(
                      totalNightmaresLastMonth,
                      zero: 'Aucun cauchemar',
                      one: '$totalNightmaresLastMonth cauchemar',
                      other: '$totalNightmaresLastMonth cauchemars',
                    ),
                  ),
                  subtitle: Text(totalNightmaresLastMonth > 0
                      ? 'soit un ratio de ${(dreamToNightmareRatioLastMonth.round())} rêves par cauchemar'
                      : ''),
                ),
                ListTile(
                  leading: const Icon(Ionicons.eye_outline),
                  title: Text(
                    Intl.plural(
                      lucidDreamsPercentageLastMonth,
                      zero: 'Aucun rêve lucide',
                      other:
                          '$lucidDreamsPercentageLastMonth% de rêves lucides',
                    ),
                  ),
                  subtitle: Text(
                    Intl.plural(
                      totalLucidDreamsLastMonth,
                      zero: '',
                      one: 'soit $totalLucidDreamsLastMonth rêve',
                      other: 'soit $totalLucidDreamsLastMonth rêves lucides',
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Ionicons.hand_left_outline),
                  title: Text(
                    Intl.plural(
                      totalControllableDreamsLastMonth,
                      zero: 'Aucun rêve contrôlable',
                      one: '$totalControllableDreamsLastMonth rêve contrôlable',
                      other:
                          '$totalControllableDreamsLastMonth rêves contrôlables',
                    ),
                  ),
                ),
              ] else ...[
                Text(
                  Intl.plural(
                    totalDreamsLastWeek,
                    zero: 'Aucun rêve enregistré cette semaine',
                    one: '$totalDreamsLastWeek rêve enregistré cette semaine',
                    other:
                        '$totalDreamsLastWeek rêves enregistrés cette semaine',
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                ListTile(
                  leading: const Icon(Ionicons.repeat_outline),
                  title: Text(
                    Intl.plural(
                      totalRecurringDreamsLastWeek,
                      zero: 'Aucun rêve récurrent',
                      one: '$totalRecurringDreamsLastWeek rêve récurrent',
                      other: '$totalRecurringDreamsLastWeek rêves récurrents',
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Ionicons.thunderstorm_outline),
                  title: Text(
                    Intl.plural(
                      totalNightmaresLastWeek,
                      zero: 'Aucun cauchemar',
                      one: '$totalNightmaresLastWeek cauchemar',
                      other: '$totalNightmaresLastWeek cauchemars',
                    ),
                  ),
                  subtitle: Text(totalNightmaresLastWeek > 0
                      ? 'soit un ratio de ${(dreamToNightmareRatioLastWeek.round())} rêves par cauchemar'
                      : ''),
                ),
                ListTile(
                  leading: const Icon(Ionicons.eye_outline),
                  title: Text(
                    Intl.plural(
                      lucidDreamsPercentageLastWeek,
                      zero: 'Aucun rêve lucide',
                      other: '$lucidDreamsPercentageLastWeek% de rêves lucides',
                    ),
                  ),
                  subtitle: Text(
                    Intl.plural(
                      totalLucidDreamsLastWeek,
                      zero: '',
                      one: 'soit $totalLucidDreamsLastWeek rêve',
                      other: 'soit $totalLucidDreamsLastWeek rêves lucides',
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Ionicons.hand_left_outline),
                  title: Text(
                    Intl.plural(
                      totalControllableDreamsLastWeek,
                      zero: 'Aucun rêve contrôlable',
                      one: '$totalControllableDreamsLastWeek rêve contrôlable',
                      other:
                          '$totalControllableDreamsLastWeek rêves contrôlables',
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => context.goNamed('sleep'),
                child: const Text('Consulter mes données de sommeil'),
              ),
              ElevatedButton(
                onPressed: () => context.goNamed('dreams'),
                child: const Text('Voir mes rêves en détail'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
