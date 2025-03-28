import 'package:objectbox/objectbox.dart';
import 'package:receipt_splitter/model/participant_bill.dart';
import 'package:receipt_splitter/model/tax_type.dart';

import '../util/calculate_bill_util.dart';
import 'menu_item.dart';
import 'participant.dart';

@Entity()
class Receipt {
  @Id(assignable: true)
  int id = 0;

  // @Unique(onConflict: ConflictStrategy.replace)
  String? uid;
  String? name;

  @Property(type: PropertyType.date)
  DateTime? date;
  double? serviceCharges;
  double? tax;
  TaxType? taxType;
  List<Participant> participants;
  List<MenuItem> items;

  Receipt({
    this.uid,
    this.name,
    this.date,
    this.serviceCharges,
    this.tax,
    this.taxType,
    this.participants = const [],
    this.items = const [],
  });

  double get subTotal {
    return items.fold(0, (sum, item) => sum + item.total);
  }

  double get taxAmount {
    return subTotal * (tax ?? 0) / 100;
  }

  double get serviceChargesAmount {
    return subTotal * (serviceCharges ?? 0) / 100;
  }

  double get total {
    return subTotal +
        serviceChargesAmount +
        (taxType == TaxType.inclusive ? 0 : taxAmount);
  }

  List<ParticipantBill> get bill => CalculateBillUtil.splitReceipt(this);
}
