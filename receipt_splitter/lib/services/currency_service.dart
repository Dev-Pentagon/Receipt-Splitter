import 'package:collection/collection.dart';
import 'package:receipt_splitter/constants/currencies.dart';
import 'package:receipt_splitter/model/currency.dart';

class CurrencyService {
  final List<Currency> _currencies;

  CurrencyService()
    : _currencies =
          currencies.map((currency) => Currency.from(json: currency)).toList();

  ///Return list with all currencies
  List<Currency> getAll() {
    return _currencies;
  }

  ///Returns the first currency that mach the given code.
  Currency? findByCode(String? code) {
    final uppercaseCode = code?.toUpperCase();
    return _currencies.firstWhereOrNull(
      (currency) => currency.code == uppercaseCode,
    );
  }

  ///Returns the first currency that mach the given name.
  Currency? findByName(String? name) {
    return _currencies.firstWhereOrNull((currency) => currency.name == name);
  }

  ///Returns the first currency that mach the given number.
  Currency? findByNumber(int? number) {
    return _currencies.firstWhereOrNull(
      (currency) => currency.number == number,
    );
  }

  ///Returns a list with all the currencies that mach the given codes list.
  List<Currency> findCurrenciesByCode(List<String> codes) {
    final List<String> codes0 =
        codes.map((code) => code.toUpperCase()).toList();
    final List<Currency> currencies = [];
    for (final code in codes0) {
      final Currency? currency = findByCode(code);
      if (currency != null) {
        currencies.add(currency);
      }
    }
    return currencies;
  }
}

class CurrencyUtils {
  /// Return Flag (Emoji Unicode) of a given currency
  static String currencyToEmoji(Currency currency) {
    final String currencyFlag = currency.flag!;
    // 0x41 is Letter A
    // 0x1F1E6 is Regional Indicator Symbol Letter A
    // Example :
    // firstLetter U => 20 + 0x1F1E6
    // secondLetter S => 18 + 0x1F1E6
    // See: https://en.wikipedia.org/wiki/Regional_Indicator_Symbol
    final int firstLetter = currencyFlag.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = currencyFlag.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }
}
