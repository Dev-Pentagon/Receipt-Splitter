import 'package:flutter/material.dart';
import 'package:receipt_splitter/config/routes.dart';

final GlobalKey<NavigatorState> navigatorKey =
GlobalKey(debugLabel: 'Main Navigator');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Receipt Splitter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: Routes.router,
    );
  }
}
