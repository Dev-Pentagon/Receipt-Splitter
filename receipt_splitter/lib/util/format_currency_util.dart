import 'package:receipt_splitter/constants/strings.dart';
import 'package:receipt_splitter/model/tax_type.dart';

import '../config/shared_pref.dart';
import '../model/currency.dart';

class FormatCurrencyUtil {
  Currency? currency;

  static final FormatCurrencyUtil _instance = FormatCurrencyUtil._internal();

  factory FormatCurrencyUtil() {
    _instance.currency ??= Preferences().getCurrencyCode();
    return _instance;
  }

  FormatCurrencyUtil._internal();

  /// Formats a given amount into a string representation with the appropriate currency symbol.
  String formatAmount(double amount) {
    return currency?.formatAmount(amount) ?? amount.toStringAsFixed(2);
  }

  String formatTaxTitle(double percentage, TaxType taxType) {
    String taxTypeText = taxType == TaxType.inclusive ? ' (incl. $percentage%)' : ' (excl. $percentage%)';
    return '$TAX $taxTypeText';
  }

  String formatServiceChargeTitle(double percentage) {
    return '$SERVICE_CHARGE ($percentage%)';
  }
}