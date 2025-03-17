import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_splitter/config/routes.dart';
import 'package:receipt_splitter/config/shared_pref.dart';
import 'package:receipt_splitter/config/theme_helper.dart';
import 'package:receipt_splitter/module/settings/cubit/theme_cubit.dart';
import 'package:receipt_splitter/module/util/id_generator_util.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: 'Main Navigator');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  IdGeneratorUtil.initialize();
  Preferences pref = Preferences();
  await pref.initPreferences();
  ThemeMode themeMode = pref.getDarkMode();
  runApp(BlocProvider(create: (context) => ThemeCubit(themeMode), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final brightness = View.of(context).platformDispatcher.platformBrightness;
    // TextTheme textTheme = MaterialTheme.createTextTheme(context, fontFamily: "Roboto");
    // MaterialTheme theme = MaterialTheme(textTheme);

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Receipt Splitter',
          // theme: brightness == Brightness.light ? theme.light() : theme.dark(),
          themeMode: themeMode,
          theme: kLightTheme,
          darkTheme: kDarkTheme,
          routerConfig: Routes.router,
        );
      },
    );
  }
}
