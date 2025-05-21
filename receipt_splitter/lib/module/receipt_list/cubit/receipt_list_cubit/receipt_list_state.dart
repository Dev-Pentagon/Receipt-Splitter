part of 'receipt_list_cubit.dart';

sealed class ReceiptListState {}

final class ReceiptListInitial extends ReceiptListState {}

final class ReceiptListLoading extends ReceiptListState {}

final class ReceiptListEmpty extends ReceiptListState {}

final class ReceiptListLoaded extends ReceiptListState {
  final List<Receipt> receipts;

  ReceiptListLoaded({required this.receipts});
}

final class ReceiptListLoadFailed extends ReceiptListState {
  final String message;

  ReceiptListLoadFailed({required this.message});
}
