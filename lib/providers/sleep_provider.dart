import 'package:flutter/material.dart';
import 'package:health/health.dart';

import '../services/sleep_service.dart';

class SleepProvider with ChangeNotifier {
  final SleepService _healthService = SleepService();
  List<HealthDataPoint> _sleepData = [];

  List<HealthDataPoint> get sleepData => _sleepData;

  Future<bool?> checkIfUserIsAuthorized() async {
    return await _healthService.hasPermissions();
  }

  // Fetch sleep data for the last 30 days
  Future<void> fetchSleepData(DateTime start, DateTime end) async {
    bool authorized = await _healthService.authorize();
    if (!authorized) {
      // Handle authorization failure
      return;
    }

    try {
      final sleepData = await _healthService.health.getHealthDataFromTypes(
        start,
        end,
        _healthService.types,
      );

      _sleepData = sleepData;
      notifyListeners();
    } catch (error) {
      // Handle error while fetching sleep data
      print('Error fetching sleep data: $error');
    }
  }

  Future<void> fetchSleepDataForDay(DateTime day) async {
    fetchSleepData(day, day.add(const Duration(days: 1)));
  }

  Future<void> fetchSleepDataForWeek(DateTime day) async {
    fetchSleepData(day, day.add(const Duration(days: 7)));
  }

  @override
  void dispose() {
    _healthService.revokeAccess();
    super.dispose();
  }
}
