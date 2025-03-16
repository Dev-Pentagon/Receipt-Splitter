part of 'receipt_form_cubit.dart';

@immutable
sealed class ReceiptFormState {}

final class ReceiptFormInitial extends ReceiptFormState {}

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
