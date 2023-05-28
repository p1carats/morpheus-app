import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:morpheus/providers/sleep_provider.dart';

class SleepMainScreen extends StatefulWidget {
  const SleepMainScreen({Key? key}) : super(key: key);

  @override
  State<SleepMainScreen> createState() => _SleepMainScreenState();
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
    _weekDays = List<DateTime>.generate(
        7, (i) => DateTime.now().add(Duration(days: i + _selectedWeek * 7)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sommeil'),
      ),
      body: Consumer<SleepProvider>(
        builder: (context, provider, child) {
          final sleepData = provider.sleepData;

          int totalMinutes =
              double.parse(sleepData[_selectedDay].value.toString()).round();
          int hours = totalMinutes ~/ 60;
          int minutes = totalMinutes % 60;
          String sleepDuration = '$hours h $minutes';

          // Fetch sleep data for at least today if not available
          if (sleepData.isEmpty) {
            provider.fetchSleepData();
            return const Center(child: CircularProgressIndicator());
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
                          provider.clearSleepData();
                          _updateWeekDays();
                          provider.fetchSleepDataForWeek(_weekDays.first);
                        });
                      },
                    ),
                    Text(
                      '${DateFormat.MMMd('fr_FR').format(_weekDays.first)} - ${DateFormat.yMMMd('fr_FR').format(_weekDays.last)}',
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: _weekDays.last.isAfter(DateTime.now())
                          ? null
                          : () {
                              setState(() {
                                _selectedWeek++;
                                _selectedDay = 0;
                                provider.clearSleepData();
                                _updateWeekDays();
                                provider.fetchSleepDataForWeek(_weekDays.first);
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
                        if (dateTime.isAfter(DateTime.now())) return;
                        setState(() {
                          _selectedDay = index;
                          provider.fetchSleepDataForDay(dateTime);
                        });
                      },
                      child: Card(
                        color: _selectedDay < sleepData.length &&
                                sleepData[_selectedDay] != null
                            ? Theme.of(context).colorScheme.surface
                            : Colors.grey[200],
                        elevation: 5,
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
                    ),
                  );
                }).toList(),
              ),
              // Sleep data for selected day...
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_selectedDay < sleepData.length &&
                          sleepData[_selectedDay] != null) ...[
                        Text(
                          'Heures de sommeil : $sleepDuration',
                        ),
                        // Check if sleep duration is more than 7 hours...
                        if (totalMinutes >= 7 * 60)
                          const Text(
                            'Vous avez dormi plus de 7 heures. Bravo !',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        else
                          const Text(
                            'Vous avez dormi moins de 7 heures. Essayez de dormir un peu plus.',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ] else
                        const Text('No data for this day'),
                      const SizedBox(height: 20),
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
