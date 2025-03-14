import 'package:flutter/material.dart';
import 'package:receipt_splitter/config/routes.dart';

import 'config/theme.dart';

final GlobalKey<NavigatorState> navigatorKey =
GlobalKey(debugLabel: 'Main Navigator');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = MaterialTheme.createTextTheme(context, fontFamily: "Roboto");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Receipt Splitter',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      routerConfig: Routes.router,
    );
  }
}
