import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

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
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Ionicons.hammer_outline),
            label: const Text('Gérer'),
            onPressed: () => context.pushNamed('settingsdata'),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Ionicons.arrow_back_outline),
                  onPressed: () {
                    setState(() {
                      _selectedWeek--;
                      _updateWeekDays();
                    });
                  },
                ),
                Text(
                    '${DateFormat.MMMd('fr_FR').format(_weekDays.first)} - ${DateFormat.yMMMd('fr_FR').format(_weekDays.last)}'),
                IconButton(
                  icon: const Icon(Ionicons.arrow_forward_outline),
                  onPressed: () {
                    setState(() {
                      _selectedWeek++;
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
                                style: const TextStyle(fontSize: 9)),
                            Text(DateFormat.d().format(dateTime),
                                style: const TextStyle(fontSize: 18)),
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
              child: Text(
                  'Date sélectionnée : ${DateFormat.yMMMd('fr_FR').format(_weekDays[_selectedDay])}'),
            ),
          ),
        ],
      ),
    );
  }
}
