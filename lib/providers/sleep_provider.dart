import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/sleep_service.dart';

class SleepProvider with ChangeNotifier {
  final SleepService _healthService = SleepService();
  List<HealthDataPoint> _sleepData = [];
  List<HealthDataPoint> get sleepData => _sleepData;

  Future<bool> isAuthorized() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isSleepAuthorized') ?? false;
  }

  Future<bool> authorize() async {
    bool? res = await _healthService.authorize();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (res == true) {
      await prefs.setBool('isSleepAuthorized', true);
    } else {
      await prefs.setBool('isSleepAuthorized', false);
    }
    return prefs.getBool('isSleepAuthorized') ?? false;
  }

  // revoke access
  Future<void> revokeAuthorization() async {
    await _healthService.revokeAccess();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSleepAuthorized', false);
  }

  Future<void> fetchSleepData() async {
    // Handle authentication failure
    bool authorized = await isAuthorized();
    if (!authorized) {
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

  // Clear sleep data
  void clearSleepData() {
    _sleepData = [];
    notifyListeners();
  }

  // Fetch sleep data for a specific day
  Future<void> fetchSleepDataForDay(DateTime day) async {
    // Handle authentication failure
    bool authorized = await isAuthorized();
    if (!authorized) {
      return;
    }

    final start = DateTime(day.year, day.month, day.day);
    final end = DateTime(day.year, day.month, day.day + 1);

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

  // display the hours of sleep for the night between yesterday and today
  String getHoursOfSleep() {
    if (_sleepData.isEmpty) {
      return '0';
    }
    double hours = 0;
    for (var i = 0; i < 2; i++) {
      hours += (double.parse(_sleepData[i].value.toString()) / 60).round();
    }
    return hours.toStringAsFixed(1);
  }

  // Fetch sleep data for a specific week
  Future<void> fetchSleepDataForWeek(DateTime day) async {
    // Handle authentication failure
    bool authorized = await isAuthorized();
    if (!authorized) {
      return;
    }

    final start = DateTime(day.year, day.month, day.day);
    final end = DateTime(day.year, day.month, day.day + 7);

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
}
