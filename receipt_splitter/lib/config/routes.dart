import 'package:go_router/go_router.dart';
import 'package:receipt_splitter/main.dart';
import 'package:receipt_splitter/model/receipt.dart';
import 'package:receipt_splitter/module/auth/screen/splash_screen.dart';
import 'package:receipt_splitter/module/onboarding/screens/onboarding_screen.dart';
import 'package:receipt_splitter/module/receipt_detail/cubit/receipt_form_cubit/receipt_form_cubit.dart';
import 'package:receipt_splitter/module/receipt_detail/cubit/receipt_type_cubit.dart';
import 'package:receipt_splitter/module/receipt_detail/screen/receipt_form_screen.dart';
import 'package:receipt_splitter/module/receipt_detail/cubit/items_and_people_cubit/items_and_people_cubit.dart';
import 'package:receipt_splitter/module/receipt_detail/screen/items_and_people_screen.dart';
import 'package:receipt_splitter/module/receipt_detail/screen/receipt_scanner_screen.dart';
import 'package:receipt_splitter/module/receipt_list/cubit/fab_cubit.dart';
import 'package:receipt_splitter/module/receipt_list/screen/receipt_list_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_splitter/module/settings/screens/currency_list_screen.dart';
import 'package:receipt_splitter/module/settings/screens/setting_screen.dart';
import 'package:receipt_splitter/repository/receipt_repository.dart';
import 'package:receipt_splitter/services/database_service.dart';
import 'package:receipt_splitter/config/shared_pref.dart';

import '../module/receipt_detail/screen/preview_screen.dart';
import '../module/receipt_list/cubit/receipt_list_cubit/receipt_list_cubit.dart';

class Routes {
  static const String splash = '/';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    navigatorKey: navigatorKey,
    routes: <RouteBase>[
      GoRoute(
        name: splash,
        path: '/',
        builder: (context, state) => const SplashScreen(),
        redirect: (context, state) {
          if (!Preferences().isOnboardingCompleted()) {
            return OnboardingScreen.tag;
          }
          return ReceiptListScreen.receiptSplit;
        },
      ),
      GoRoute(
        name: OnboardingScreen.tag,
        path: OnboardingScreen.tag,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        name: ReceiptListScreen.receiptSplit,
        path: ReceiptListScreen.receiptSplit,
        builder:
            (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create:
                      (context) => ReceiptListCubit(
                        ReceiptRepositoryImpl(DatabaseService()),
                      )..loadReceipts(),
                ),
                BlocProvider(create: (context) => FabCubit()),
                BlocProvider(
                  create:
                      (context) => ReceiptFormCubit(
                        ReceiptRepositoryImpl(DatabaseService()),
                      ),
                ),
              ],
              child: const ReceiptListScreen(),
            ),
      ),
      GoRoute(
        name: ItemsAndPeopleScreen.itemsAndPeople,
        path: ItemsAndPeopleScreen.itemsAndPeople,
        builder:
            (context, state) => BlocProvider(
              create:
                  (context) => ItemsAndPeopleCubit(
                    ReceiptRepositoryImpl(DatabaseService()),
                  ),
              child: ItemsAndPeopleScreen(receipt: state.extra as Receipt),
            ),
      ),
      GoRoute(
        name: PreviewScreen.preview,
        path: PreviewScreen.preview,
        builder:
            (context, state) => PreviewScreen(receipt: state.extra as Receipt),
      ),
      GoRoute(
        name: ReceiptFormScreen.receiptForm,
        path: ReceiptFormScreen.receiptForm,
        builder:
            (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => ReceiptTypeCubit()),
                BlocProvider(
                  create:
                      (context) => ReceiptFormCubit(
                        ReceiptRepositoryImpl(DatabaseService()),
                      ),
                ),
              ],
              child: ReceiptFormScreen(
                arguments: state.extra as ReceiptFormScreenArguments,
              ),
            ),
      ),
      GoRoute(
        name: ReceiptScannerScreen.scan,
        path: ReceiptScannerScreen.scan,
        builder: (context, state) => const ReceiptScannerScreen(),
      ),
      GoRoute(
        name: SettingScreen.tag,
        path: SettingScreen.tag,
        builder: (context, state) => const SettingScreen(),
      ),
      GoRoute(
        name: CurrencyListView.tag,
        path: CurrencyListView.tag,
        builder: (context, state) => const CurrencyListView(),
      ),
    ],
  );
}
