import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_splitter/config/shared_pref.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(super.themeMode);

  void toggleTheme({bool? value}) {
    if (value != null) {
      if (value) {
        emit(ThemeMode.dark);
        Preferences().setDarkMode(true);
      } else {
        emit(ThemeMode.light);
        Preferences().setDarkMode(false);
      }
    } else {
      if (state == ThemeMode.light) {
        emit(ThemeMode.dark);
        Preferences().setDarkMode(true);
      } else {
        emit(ThemeMode.light);
        Preferences().setDarkMode(false);
      }
    }
  }
}
