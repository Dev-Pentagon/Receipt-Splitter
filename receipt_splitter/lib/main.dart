import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_splitter/config/routes.dart';
import 'package:receipt_splitter/config/shared_pref.dart';
import 'package:receipt_splitter/module/settings/cubit/theme_cubit.dart';
import 'package:receipt_splitter/util/id_generator_util.dart';

import 'config/theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey(
  debugLabel: 'Main Navigator',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  IdGeneratorUtil.initialize();
  Preferences pref = Preferences();
  await pref.initPreferences();
  ThemeMode themeMode = pref.getThemeMode();
  runApp(
    BlocProvider(
      create: (context) => ThemeCubit(themeMode),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = MaterialTheme.createTextTheme(
      context,
      fontFamily: 'Roboto',
    );
    MaterialTheme theme = MaterialTheme(textTheme);

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [],
          locale: const Locale('en', 'US'),
          title: 'Receipt Splitter',
          themeMode: themeMode,
          theme: theme.light(),
          darkTheme: theme.dark(),
          routerConfig: Routes.router,
        );
      },
    );
  }
}
