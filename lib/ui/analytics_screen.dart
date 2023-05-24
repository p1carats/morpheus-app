import 'package:flutter/material.dart';
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

class _AnalyticsMainScreenState extends State<AnalyticsMainScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.book_outlined),
              text: 'Sommeil',
            ),
            Tab(
              icon: Icon(Ionicons.eye_outline),
              text: 'Rêves',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          SleepTab(),
          DreamTab(),
        ],
      ),
    );
  }
}

class SleepTab extends StatefulWidget {
  const SleepTab({Key? key}) : super(key: key);

  @override
  _SleepTabState createState() => _SleepTabState();
}

class _SleepTabState extends State<SleepTab> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Placeholder(),
    );
  }
}

class DreamTab extends StatefulWidget {
  const DreamTab({Key? key}) : super(key: key);

  @override
  _DreamTabState createState() => _DreamTabState();
}

class _DreamTabState extends State<DreamTab> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DreamProvider>(context, listen: false);
    String _selectedDuration = 'month';

    final totalDreamsLastWeek = provider.filteredDreams
        .where((dream) => dream.date
            .isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .length;
    final totalDreamsLastMonth = provider.filteredDreams
        .where((dream) => dream.date
            .isAfter(DateTime.now().subtract(const Duration(days: 30))))
        .length;

    final totalNightmaresLastWeek = provider.filteredDreams
        .where((dream) =>
            dream.date
                .isAfter(DateTime.now().subtract(const Duration(days: 7))) &&
            dream.type == DreamType.nightmare)
        .length;
    final totalNightmaresLastMonth = provider.filteredDreams
        .where((dream) =>
            dream.date
                .isAfter(DateTime.now().subtract(const Duration(days: 30))) &&
            dream.type == DreamType.nightmare)
        .length;

    final dreamToNightmareRatioLastWeek =
        provider.getDreamNightmareRatio(const Duration(days: 7));
    final dreamToNightmareRatioLastMonth =
        provider.getDreamNightmareRatio(const Duration(days: 30));

    final totalRecurringDreamsLastWeek = provider.filteredDreams
        .where((dream) =>
            dream.date
                .isAfter(DateTime.now().subtract(const Duration(days: 7))) &&
            dream.isRecurrent)
        .length;
    final totalRecurringDreamsLastMonth = provider.filteredDreams
        .where((dream) =>
            dream.date
                .isAfter(DateTime.now().subtract(const Duration(days: 30))) &&
            dream.isRecurrent)
        .length;

    final totalLucidDreamsLastWeek = provider.filteredDreams
        .where((dream) =>
            dream.date
                .isAfter(DateTime.now().subtract(const Duration(days: 7))) &&
            dream.isLucid)
        .length;
    final totalLucidDreamsLastMonth = provider.filteredDreams
        .where((dream) =>
            dream.date
                .isAfter(DateTime.now().subtract(const Duration(days: 30))) &&
            dream.isLucid)
        .length;

    final lucidDreamsPercentageLastWeek =
        (provider.getLucidDreamPercentage(const Duration(days: 7)) * 100)
            .round();
    final lucidDreamsPercentageLastMonth =
        (provider.getLucidDreamPercentage(const Duration(days: 30)) * 100)
            .round();

    final totalControllableDreamsLastWeek = provider.filteredDreams
        .where((dream) =>
            dream.date
                .isAfter(DateTime.now().subtract(const Duration(days: 7))) &&
            dream.isControllable)
        .length;
    final totalControllableDreamsLastMonth = provider.filteredDreams
        .where((dream) =>
            dream.date
                .isAfter(DateTime.now().subtract(const Duration(days: 30))) &&
            dream.isControllable)
        .length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
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
                });
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
                    other: '$lucidDreamsPercentageLastMonth% de rêves lucides',
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
                  other: '$totalDreamsLastWeek rêves enregistrés cette semaine',
                ),
                style: Theme.of(context).textTheme.titleLarge,
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
              onPressed: () => context.goNamed('dreams'),
              child: const Text('Voir mes rêves en détail'),
            ),
          ],
        ),
      ),
    );
  }
}
