import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:morpheus/services/sleep_service.dart'; // Replace with the correct import path for your HealthService class

class SleepDataPage extends StatefulWidget {
  const SleepDataPage({Key? key}) : super(key: key);

  @override
  _SleepDataPageState createState() => _SleepDataPageState();
}

class _SleepDataPageState extends State<SleepDataPage> {
  final HealthService _healthService = HealthService();
  List<HealthDataPoint> _sleepData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Data'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _fetchSleepData();
            },
            child: const Text('Get Sleep Data'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _sleepData.length,
              itemBuilder: (context, index) {
                final sleep = _sleepData[index];
                return ListTile(
                  title: Text('${sleep.value} minutes'),
                  subtitle: Text('${sleep.dateFrom} - ${sleep.dateTo}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchSleepData() async {
    bool authorized = await _healthService.authorize();
    if (!authorized) {
      // Handle authorization failure
      return;
    }

    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 1, now.day);
    final end = DateTime(now.year, now.month, now.day);

    try {
      final sleepData = await _healthService.health.getHealthDataFromTypes(
        start,
        end,
        _healthService.types,
      );

      setState(() {
        _sleepData = sleepData;
      });
    } catch (error) {
      // Handle error while fetching sleep data
      print('Error fetching sleep data: $error');
    }
  }

  @override
  void dispose() {
    _healthService.revokeAccess();
    super.dispose();
  }
}
