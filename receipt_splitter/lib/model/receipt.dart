import 'package:receipt_splitter/config/shared_pref.dart';
import 'package:receipt_splitter/model/currency.dart';
import 'package:receipt_splitter/model/tax_type.dart';

import 'menu_item.dart';
import 'participant.dart';

class Receipt {
  String? id;
  String? name;
  DateTime? date;
  double? serviceCharges;
  double? tax;
  TaxType? taxType;
  List<Participant> participants;
  List<MenuItem> items;

  Receipt({this.id, this.name, this.date, this.serviceCharges, this.tax, this.taxType, this.participants = const [], this.items = const []});

  Currency get _countryCode => Preferences().getCurrencyCode();

  String get subTotal {
    double subtotal = items.fold(0, (sum, item) => sum + item.total);
    return _countryCode.formatAmount(subtotal);
  }

  String get taxAmount {
    double subtotal = items.fold(0, (sum, item) => sum + item.total);
    double taxAmount = subtotal * (tax ?? 0) / 100;
    return _countryCode.formatAmount(taxAmount);
  }

  String get serviceChargesAmount {
    double subtotal = items.fold(0, (sum, item) => sum + item.total);
    double serviceChargesAmount = subtotal * (serviceCharges ?? 0) / 100;
    return _countryCode.formatAmount(serviceChargesAmount);
  }

  String get total {
    double subtotal = items.fold(0, (sum, item) => sum + item.total);
    double taxAmount = subtotal * (tax ?? 0) / 100;
    double serviceChargesAmount = subtotal * (serviceCharges ?? 0) / 100;

    if (taxType == TaxType.inclusive) {
      return _countryCode.formatAmount(subtotal + serviceChargesAmount);
    } else {
      return _countryCode.formatAmount(subtotal + taxAmount + serviceChargesAmount);
    }
  }
}
