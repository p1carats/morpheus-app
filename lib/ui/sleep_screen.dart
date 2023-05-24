import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:morpheus/providers/sleep_provider.dart';
import 'package:provider/provider.dart';

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
    //SleepProvider().fetchSleepData();
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
                          provider.clearSleepData();
                          provider.fetchSleepDataForDay(dateTime);
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
                      Text(
                        'Heures de sommeil : ${(double.parse(sleepData[_selectedDay].value.toString()) / 60).toStringAsFixed(0)}h',
                      ),
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
