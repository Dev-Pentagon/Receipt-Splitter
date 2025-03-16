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
}
