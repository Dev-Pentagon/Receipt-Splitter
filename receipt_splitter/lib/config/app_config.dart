import 'package:intl/intl.dart';
import 'package:receipt_splitter/model/currency.dart';

NumberFormat amountFormatter = NumberFormat('#,###,##0');
NumberFormat qtyFormatter = NumberFormat('#,###,##0');
DateFormat dateFormatter = DateFormat('dd/MM/yyyy');

enum IdentifierType {
  receipt('RCP'),
  menuItem('ITM'),
  participant('PRT');

  final String code;

  const IdentifierType(this.code);
}

Currency get defaultCurrency {
  return Currency.from(
    json: {
      "code": "MMK",
      "name": "Myanmar Kyat",
      "symbol": "Ks",
      "flag": "MM",
      "decimal_digits": 2,
      "number": 104,
      "name_plural": "Myanmar Kyats",
      "thousands_separator": ",",
      "decimal_separator": ".",
      "space_between_amount_and_symbol": true,
      "symbol_on_left": true,
    },
  );
}
