part of 'receipt_form_cubit.dart';

@immutable
sealed class ReceiptFormState {}

final class ReceiptFormInitial extends ReceiptFormState {}

final class ReceiptFormLoaded extends ReceiptFormState {
  final Receipt receipt;

  ReceiptFormLoaded({required this.receipt});
}

final class ReceiptFormSaved extends ReceiptFormState {
  final Receipt receipt;

  ReceiptFormSaved({required this.receipt});
}

final class ReceiptFormUpdated extends ReceiptFormState {
  final Receipt receipt;

  ReceiptFormUpdated({required this.receipt});
}

final class ParticipantUpdated extends ReceiptFormState {
  final List<Participant> participants;

  ParticipantUpdated({required this.participants});
}

final class MenuItemUpdated extends ReceiptFormState {
  final List<MenuItem> items;

  MenuItemUpdated({required this.items});
}

final class ReceiptFormSaveFailed extends ReceiptFormState {
  final String message;

  ReceiptFormSaveFailed({required this.message});
}

final class ReceiptDeletedSuccessfully extends ReceiptFormState {}

final class ReceiptDeletedFailed extends ReceiptFormState {
  final String message;

  ReceiptDeletedFailed({required this.message});
}
