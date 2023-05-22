import 'package:flutter/material.dart';
import 'package:health/health.dart';

import '../services/sleep_service.dart';

class SleepProvider with ChangeNotifier {
  final SleepService _healthService = SleepService();
  List<HealthDataPoint> _sleepData = [];

  List<HealthDataPoint> get sleepData => _sleepData;

  Future<void> fetchSleepData() async {
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

      _sleepData = sleepData;
      notifyListeners();
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
