import 'package:flutter/foundation.dart';
import 'package:health/health.dart';

import '../services/sleep_service.dart';

class HealthDataProvider with ChangeNotifier {
  List<HealthDataPoint> sleepData = [];
  final HealthService _healthService = HealthService();

  HealthDataProvider() {
    fetchSleepData();
  }

  fetchSleepData() async {
    sleepData = await _healthService.getSleepData();
    notifyListeners();
  }
}
