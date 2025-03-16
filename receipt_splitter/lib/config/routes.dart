import 'package:go_router/go_router.dart';
import 'package:receipt_splitter/main.dart';
import 'package:receipt_splitter/model/receipt.dart';
import 'package:receipt_splitter/module/auth/screen/splash_screen.dart';
import 'package:receipt_splitter/module/receipt_detail/cubit/receipt_form_cubit/receipt_form_cubit.dart';
import 'package:receipt_splitter/module/receipt_detail/cubit/receipt_form_cubit/receipt_type_cubit.dart';
import 'package:receipt_splitter/module/receipt_detail/screen/receipt_form_screen.dart';
import 'package:receipt_splitter/module/receipt_detail/cubit/items_and_people_cubit/items_and_people_cubit.dart';
import 'package:receipt_splitter/module/receipt_detail/screen/items_and_people_screen.dart';
import 'package:receipt_splitter/module/receipt_list/cubit/fab_cubit.dart';
import 'package:receipt_splitter/module/receipt_list/screen/receipt_list_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Routes {
  static const String splash = '/';

  static final GoRouter router = GoRouter(
    initialLocation: ReceiptListScreen.receiptSplit,
    debugLogDiagnostics: true,
    navigatorKey: navigatorKey,
    routes: <RouteBase>[
      GoRoute(name: splash, path: '/', builder: (context, state) => SplashScreen()),
      GoRoute(name: ReceiptListScreen.receiptSplit, path: '/receiptSplit', builder: (context, state) => BlocProvider(create: (context) => FabCubit(), child: ReceiptListScreen())),
      GoRoute(
        name: ItemsAndPeopleScreen.itemsAndPeople,
        path: '/itemsAndPeople',
        builder: (context, state) => BlocProvider(create: (context) => ItemsAndPeopleCubit(), child: ItemsAndPeopleScreen(receipt: state.extra as Receipt)),
      ),
      GoRoute(
        name: ReceiptFormScreen.receiptForm,
        path: '/receiptForm',
        builder:
            (context, state) => MultiBlocProvider(
              providers: [BlocProvider(create: (context) => ReceiptTypeCubit()), BlocProvider(create: (context) => ReceiptFormCubit())],
              child: ReceiptFormScreen(arguments: state.extra as ReceiptFormScreenArguments),
            ),
      ),
    ],
  );
}
