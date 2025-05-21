import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/receipt.dart';
import '../../../../repository/receipt_repository.dart';

part 'receipt_list_state.dart';

class ReceiptListCubit extends Cubit<ReceiptListState> {
  final ReceiptRepository repository;

  ReceiptListCubit(this.repository) : super(ReceiptListInitial());

  void loadReceipts() async {
    try {
      emit(ReceiptListLoading());
      List<Receipt> receipts = await repository.getReceipts();
      if (receipts.isNotEmpty) {
        emit(ReceiptListLoaded(receipts: receipts));
      } else {
        emit(ReceiptListEmpty());
      }
    } catch (e) {
      emit(ReceiptListLoadFailed(message: 'Failed to load receipts: $e'));
    }
  }
}
