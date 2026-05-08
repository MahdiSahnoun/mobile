import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _key = 'is_dark_theme';

  Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isDark);
  }

  Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? true; // Default to dark
  }
}

class ThemeNotifier extends ValueNotifier<bool> {
  ThemeNotifier(bool value) : super(value);

  void toggleTheme(bool isDark) {
    value = isDark;
    ThemeService().saveTheme(isDark);
  }
}
