import 'package:go_router/go_router.dart';
import 'package:receipt_splitter/main.dart';
import 'package:receipt_splitter/module/auth/screen/splash_screen.dart';
import 'package:receipt_splitter/module/receipt_list/cubit/fab_cubit.dart';
import 'package:receipt_splitter/module/receipt_list/screen/receipt_list_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class Routes {
  static const String splash = '/receiptSplit';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    navigatorKey: navigatorKey,
    routes: <RouteBase>[
      GoRoute(name: splash, path: '/', builder: (context, state) => SplashScreen()),
      GoRoute(name: ReceiptListScreen.receiptSplit, path: '/receiptSplit', builder: (context, state) => BlocProvider(create: (context) => FabCubit(), child: ReceiptListScreen())),
    ],
  );
}
