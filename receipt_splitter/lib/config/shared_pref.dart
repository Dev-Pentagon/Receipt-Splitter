import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:receipt_splitter/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/currency.dart';

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

  ThemeMode getThemeMode() {
    bool? darkModePref = _prefs.getBool(_isDarkMode);

    if (darkModePref == null) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      final bool isDarkMode = brightness == Brightness.dark;
      setDarkMode(isDarkMode);
      darkModePref = isDarkMode;
    }
    return darkModePref ? ThemeMode.dark : ThemeMode.light;
  }

  void setDarkMode(bool darkMode) {
    _prefs.setBool(_isDarkMode, darkMode);
  }

  Currency getCurrencyCode() {
    String? jsonString = _prefs.getString(_currencyCode);

    if (jsonString == null) {
      setCurrencyCode(defaultCurrency);
    }

    return jsonString != null
        ? Currency.from(json: jsonDecode(jsonString))
        : defaultCurrency;
  }

  void setCurrencyCode(Currency currency) {
    _prefs.setString(_currencyCode, jsonEncode(currency.toJson()));
  }

  void clear() {
    _prefs.clear();
  }

  void reload() {
    _prefs.reload();
  }
}
