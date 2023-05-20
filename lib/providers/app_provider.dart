import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeType { system, light, dark }

class AppProvider extends ChangeNotifier {
  ThemeType _themeType = ThemeType.system;
  bool _hasCompletedOnboarding = false;

  AppProvider() {
    _loadThemeType();
  }

  ThemeType get themeType => _themeType;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;

  Future<void> checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _hasCompletedOnboarding = (prefs.getBool('seen') ?? false);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', true);
    _hasCompletedOnboarding = true;
    notifyListeners();
  }

  void _loadThemeType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int themeIndex = prefs.getInt('themeType') ?? 2;
    _themeType = ThemeType.values[themeIndex];
    notifyListeners();
  }

  void updateThemeType(ThemeType type) {
    if (type != _themeType) {
      _themeType = type;
      notifyListeners();
    }
  }
}
