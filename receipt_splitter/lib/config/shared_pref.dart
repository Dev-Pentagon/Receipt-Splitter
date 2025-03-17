

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  late SharedPreferences _prefs;
  Preferences._private();

  static final _instance = Preferences._private();

  factory Preferences() {
    return _instance;
  }
  Future<void> initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  final String _isDarkMode = 'isDarkMode';
  final String _currencyCode = 'currencyCode';
  ThemeMode getDarkMode() {
    
    // final brightness = View.of(context).platformDispatcher.platformBrightness;
    final darkMode = _prefs.getBool(_isDarkMode) ?? false;
    return darkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void setDarkMode(bool darkMode) {
    _prefs.setBool(_isDarkMode,  darkMode);
  }
  String getCurrencyCode() {
    return _prefs.getString(_currencyCode) ?? 'MMK';
  }

  void setCurrencyCode(String code) {
    _prefs.setString(_currencyCode,  code);
  }

  void clear() {
    _prefs.clear();
  }

  void reload(){
    _prefs.reload();
  }
}