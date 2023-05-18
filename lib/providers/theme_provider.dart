import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeType { system, light, dark }

class ThemeProvider extends ChangeNotifier {
  ThemeType _themeType = ThemeType.system;

  ThemeProvider() {
    _loadThemeType();
  }

  ThemeType get themeType => _themeType;

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
