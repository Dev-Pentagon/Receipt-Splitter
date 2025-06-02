import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_splitter/config/app_config.dart';
import 'package:receipt_splitter/model/currency.dart';

class OnboardingCubit extends Cubit<Currency> {
  OnboardingCubit() : super(defaultCurrency);

  void setCurrency(Currency currency) {
    emit(currency);
  }
}