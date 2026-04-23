import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends GetxService {
  static ThemeService get to => Get.find();
  late SharedPreferences _prefs;
  final _key = 'isDarkMode';

  Future<ThemeService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  ThemeMode get theme => _loadThemeFromPrefs() ? ThemeMode.dark : ThemeMode.light;

  bool _loadThemeFromPrefs() {
    return _prefs.getBool(_key) ?? false;
  }

  void _saveThemeToPrefs(bool isDarkMode) {
    _prefs.setBool(_key, isDarkMode);
  }

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromPrefs() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToPrefs(!_loadThemeFromPrefs());
  }
}
