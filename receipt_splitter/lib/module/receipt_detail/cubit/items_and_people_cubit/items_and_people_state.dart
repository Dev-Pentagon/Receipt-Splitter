part of 'items_and_people_cubit.dart';

@immutable
sealed class ItemsAndPeopleState {}

final class ItemsAndPeopleInitial extends ItemsAndPeopleState {}

final class ItemsAndPeopleUpdated extends ItemsAndPeopleState {
  final List<MenuItem> items;
  final bool fromDelete;

  ItemsAndPeopleUpdated({required this.items, required this.fromDelete});
}

final class AlreadyLinked extends ItemsAndPeopleState {}

final class DialogUpdated extends ItemsAndPeopleState {}
