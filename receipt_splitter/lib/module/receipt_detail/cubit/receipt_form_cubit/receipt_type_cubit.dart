import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_splitter/model/receipt_type.dart';

class ReceiptTypeCubit extends Cubit<ReceiptType> {
  ReceiptTypeCubit() : super(ReceiptType.inclusive);

  void toggle() {
    emit(state == ReceiptType.inclusive ? ReceiptType.exclusive : ReceiptType.inclusive);
  }
}
