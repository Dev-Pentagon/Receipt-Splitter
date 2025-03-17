import 'package:flutter/material.dart';

bool isDarkTheme(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

ThemeData kLightTheme = ThemeData(
  dialogTheme: const DialogTheme(elevation: 0.0),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      surfaceTintColor: Colors.transparent,
      disabledBackgroundColor: const Color(0x61000000),
    ),
  ),
  tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(const Color(0xFF272727)), // Set the TextButton text color
    ),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xFF272727),
  ),
  radioTheme: const RadioThemeData(
    fillColor: WidgetStatePropertyAll(
      Color(0xFF005BAA),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        // return AppTheme.logoColor; // Active color
      }
      return null;
    }),
  ),
  cardColor: const Color(0xFFFFFFFF),
  colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: const Color(0xFF005BAA),
      primaryContainer: const Color(0xFF3d83ff),
      secondary: const Color(0xFFFFFFFF),
      secondaryContainer: const Color(0xFF272727),
      onSurface: const Color(0xFFFFFFFF),
      surface: const Color(0xFFFFFFFF),
      onSecondary: Color(0xFFFFFFFF),
      onSecondaryContainer: HexColor('#204183c4'),
      onPrimary: const Color(0xFFFAFAFA),
      tertiary: const Color(0xFFE2E2E2),
      onTertiaryContainer: const Color(0xFFCECECE),
      brightness: Brightness.light,
      // onPrimaryContainer: AppTheme.textFieldTitleColor
      ),
);

ThemeData kDarkTheme = ThemeData(
  tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
  scaffoldBackgroundColor: const Color(0xFF151a30),
  dialogBackgroundColor: const Color(0xFF151a30),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      surfaceTintColor: Colors.transparent,
      disabledBackgroundColor: const Color(0x61FFFFFF),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(const Color(0xFFFEFEFE)),
    ),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xFFFEFEFE),
  ),
  radioTheme: const RadioThemeData(
    fillColor: WidgetStatePropertyAll(
      Color(0xFF3d83ff),
    ),
  ),
  cardColor: const Color(0xFF1a1f38),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      // if (states.contains(WidgetState.selected)) {
      //   return AppTheme.logoColor; // Active color
      // }
      return null;
    }),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xFF1a1f38),
    primaryContainer: const Color(0xFF3d83ff),
    secondary: const Color(0xFF151a30),
    secondaryContainer: const Color(0xFFFEFEFE),
    onSurface: const Color(0xFF151a30),
    surface: const Color(0xFFFFFFFF),
    onSecondary: HexColor('#151a30'),
    onSecondaryContainer: HexColor('#30385D'),
    onPrimary: HexColor('#30385D'),
    tertiary: const Color(0xFF1a1f38),
    onTertiaryContainer: const Color(0xFF1A1F38),
    brightness: Brightness.dark,
    // onPrimaryContainer: AppTheme.whiteSmokeColor,
  ),
);

class HexColor extends Color {
  HexColor(String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}