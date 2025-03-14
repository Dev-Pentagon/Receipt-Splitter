import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme _lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff65558f),
      surfaceTint: Color(0xff65558f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffe9ddff),
      onPrimaryContainer: Color(0xff4d3d75),
      secondary: Color(0xff65558f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffe9ddff),
      onSecondaryContainer: Color(0xff4d3d75),
      tertiary: Color(0xff8b4a61),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffd9e3),
      onTertiaryContainer: Color(0xff6f334a),
      error: Color(0xff904a42),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad5),
      onErrorContainer: Color(0xff73342c),
      surface: Color(0xfffdf7ff),
      onSurface: Color(0xff1c1b20),
      onSurfaceVariant: Color(0xff48454e),
      outline: Color(0xff79757f),
      outlineVariant: Color(0xffc9c4d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff322f35),
      inversePrimary: Color(0xffcfbdfe),
      primaryFixed: Color(0xffe9ddff),
      onPrimaryFixed: Color(0xff211047),
      primaryFixedDim: Color(0xffcfbdfe),
      onPrimaryFixedVariant: Color(0xff4d3d75),
      secondaryFixed: Color(0xffe9ddff),
      onSecondaryFixed: Color(0xff210f47),
      secondaryFixedDim: Color(0xffd0bcfe),
      onSecondaryFixedVariant: Color(0xff4d3d75),
      tertiaryFixed: Color(0xffffd9e3),
      onTertiaryFixed: Color(0xff3a071e),
      tertiaryFixedDim: Color(0xffffb0ca),
      onTertiaryFixedVariant: Color(0xff6f334a),
      surfaceDim: Color(0xffded8e0),
      surfaceBright: Color(0xfffdf7ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff7f2fa),
      surfaceContainer: Color(0xfff2ecf4),
      surfaceContainerHigh: Color(0xffece6ee),
      surfaceContainerHighest: Color(0xffe6e1e9),
    );
  }

  ThemeData light() {
    return _theme(_lightScheme());
  }

  static ColorScheme _darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffcfbdfe),
      surfaceTint: Color(0xffcfbdfe),
      onPrimary: Color(0xff36265d),
      primaryContainer: Color(0xff4d3d75),
      onPrimaryContainer: Color(0xffe9ddff),
      secondary: Color(0xffd0bcfe),
      onSecondary: Color(0xff36265d),
      secondaryContainer: Color(0xff4d3d75),
      onSecondaryContainer: Color(0xffe9ddff),
      tertiary: Color(0xffffb0ca),
      onTertiary: Color(0xff541d33),
      tertiaryContainer: Color(0xff6f334a),
      onTertiaryContainer: Color(0xffffd9e3),
      error: Color(0xffffb4aa),
      onError: Color(0xff561e18),
      errorContainer: Color(0xff73342c),
      onErrorContainer: Color(0xffffdad5),
      surface: Color(0xff141318),
      onSurface: Color(0xffe6e1e9),
      onSurfaceVariant: Color(0xffc9c4d0),
      outline: Color(0xff938f99),
      outlineVariant: Color(0xff48454e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e1e9),
      inversePrimary: Color(0xff65558f),
      primaryFixed: Color(0xffe9ddff),
      onPrimaryFixed: Color(0xff211047),
      primaryFixedDim: Color(0xffcfbdfe),
      onPrimaryFixedVariant: Color(0xff4d3d75),
      secondaryFixed: Color(0xffe9ddff),
      onSecondaryFixed: Color(0xff210f47),
      secondaryFixedDim: Color(0xffd0bcfe),
      onSecondaryFixedVariant: Color(0xff4d3d75),
      tertiaryFixed: Color(0xffffd9e3),
      onTertiaryFixed: Color(0xff3a071e),
      tertiaryFixedDim: Color(0xffffb0ca),
      onTertiaryFixedVariant: Color(0xff6f334a),
      surfaceDim: Color(0xff141318),
      surfaceBright: Color(0xff3a383e),
      surfaceContainerLowest: Color(0xff0f0d13),
      surfaceContainerLow: Color(0xff1c1b20),
      surfaceContainer: Color(0xff211f24),
      surfaceContainerHigh: Color(0xff2b292f),
      surfaceContainerHighest: Color(0xff36343a),
    );
  }

  ThemeData dark() {
    return _theme(_darkScheme());
  }

  ThemeData _theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );

  static TextTheme createTextTheme(BuildContext context, {required String fontFamily}) {
    TextTheme baseTextTheme = Theme.of(context).textTheme;

    TextTheme textTheme = baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(fontFamily: fontFamily),
      displayMedium: baseTextTheme.displayMedium?.copyWith(fontFamily: fontFamily),
      displaySmall: baseTextTheme.displaySmall?.copyWith(fontFamily: fontFamily),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontFamily: fontFamily),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontFamily: fontFamily),
      bodySmall: baseTextTheme.bodySmall?.copyWith(fontFamily: fontFamily),
      labelLarge: baseTextTheme.labelLarge?.copyWith(fontFamily: fontFamily),
      labelMedium: baseTextTheme.labelMedium?.copyWith(fontFamily: fontFamily),
      labelSmall: baseTextTheme.labelSmall?.copyWith(fontFamily: fontFamily),
    );

    return textTheme;
  }

  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
