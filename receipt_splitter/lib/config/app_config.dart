import 'package:intl/intl.dart';

NumberFormat amountFormatter = NumberFormat('#,###,##0');
NumberFormat qtyFormatter = NumberFormat('#,###,##0');
DateFormat dateFormatter = DateFormat('dd/MM/yyyy');

enum IdentifierType {
  receipt('RCP'),
  menuItem('ITM'),
  participant('PRT'),;

  final String code;

  const IdentifierType(this.code);
}