import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../providers/sleep_provider.dart';

class SleepMainScreen extends StatefulWidget {
  const SleepMainScreen({Key? key}) : super(key: key);

  @override
  _SleepMainScreenState createState() => _SleepMainScreenState();
}

class _SleepMainScreenState extends State<SleepMainScreen> {
  int _selectedDay = 0;
  int _selectedWeek = 0;
  List<DateTime> _weekDays = [];

  @override
  void initState() {
    super.initState();
    _updateWeekDays();
  }

  void _updateWeekDays() {
    _weekDays = List<DateTime>.generate(7,
        (i) => DateTime.now().subtract(Duration(days: i + _selectedWeek * 7)));

    // Fetch sleep data for current week
    Provider.of<SleepProvider>(context, listen: false)
        .fetchSleepDataForWeek(_weekDays.first);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sommeil'),
      ),
      body: Consumer<SleepProvider>(
        builder: (context, provider, child) {
          // Fetch sleep data for selected day
          if (provider.sleepData.isEmpty ||
              provider.checkIfUserIsAuthorized() as bool == false) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Vous n\'avez pas autorisé l\'accès à vos données de sommeil. Elles ne sont donc pas disponibles dans l\'application pour le moment.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () => context.pushNamed('settingsdata'),
                      child: const Text('Accéder aux paramètres'),
                    ),
                  ],
                ),
              ),
            );
          }
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          _selectedWeek--;
                          _selectedDay = 0;
                          _updateWeekDays();
                        });
                      },
                    ),
                    Text(
                      '${DateFormat.MMMd('fr_FR').format(_weekDays.first)} - ${DateFormat.yMMMd('fr_FR').format(_weekDays.last)}',
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        setState(() {
                          _selectedWeek++;
                          _selectedDay = 0;
                          _updateWeekDays();
                        });
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _weekDays.map((DateTime dateTime) {
                  int index = _weekDays.indexOf(dateTime);
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDay = index;
                          provider
                              .fetchSleepDataForDay(_weekDays[_selectedDay]);
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: _selectedDay == index
                                ? Theme.of(context).colorScheme.onPrimary
                                : Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat.E('fr_FR')
                                      .format(dateTime)
                                      .toLowerCase(),
                                  style: const TextStyle(fontSize: 9),
                                ),
                                Text(
                                  DateFormat.d().format(dateTime),
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Here you may need to adapt according to your sleepData structure and value extraction
                      Text(
                        '${provider.sleepData[_selectedDay].value}h de sommeil',
                      ),
                      const SizedBox(height: 20),
                      Text(
                        DateFormat('EEEE, d MMMM').format(
                          _weekDays[_selectedDay < 0
                              ? _weekDays.length - 1
                              : _selectedDay],
                        ),
                      ),
                      Container(
                        height: 200,
                        padding: const EdgeInsets.all(16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
