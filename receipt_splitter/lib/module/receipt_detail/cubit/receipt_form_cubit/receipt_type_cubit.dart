import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_splitter/model/tax_type.dart' show TaxType;

class ReceiptTypeCubit extends Cubit<TaxType> {
  ReceiptTypeCubit() : super(TaxType.inclusive);

  void toggle() {
    emit(state == TaxType.inclusive ? TaxType.exclusive : TaxType.inclusive);
  }
}
