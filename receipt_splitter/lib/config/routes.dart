import 'package:go_router/go_router.dart';
import 'package:receipt_splitter/main.dart';
import 'package:receipt_splitter/module/auth/screen/splash_screen.dart';

class Routes {
  static const String splash = '/';
  static const String receiptSplit = '/receipt-split';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    navigatorKey: navigatorKey,
    routes: <RouteBase>[GoRoute(name: splash, path: '/', builder: (context, state) => SplashScreen())],
  );
}
