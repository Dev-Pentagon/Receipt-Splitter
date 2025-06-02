import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:receipt_splitter/model/currency.dart';
import 'package:receipt_splitter/util/format_currency_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_config.dart';

class Preferences {
  static final Preferences _instance = Preferences._internal();
  late SharedPreferences _prefs;

  factory Preferences() {
    return _instance;
  }

  Preferences._internal();

  Future<void> initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String _isDarkMode = 'is_dark_mode';
  static const String _currencyCode = 'currency_code';
  static const String _onboardingCompletedKey = 'onboarding_completed';

  ThemeMode getThemeMode() {
    bool? darkModePref = _prefs.getBool(_isDarkMode);

    if (darkModePref == null) {
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
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

    return jsonString != null ? Currency.from(json: jsonDecode(jsonString)) : defaultCurrency;
  }

  void setCurrencyCode(Currency currency) {
    FormatCurrencyUtil.dispose();
    _prefs.setString(_currencyCode, jsonEncode(currency.toJson()));
  }

  bool isOnboardingCompleted() {
    return _prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(_onboardingCompletedKey, completed);
  }
}
