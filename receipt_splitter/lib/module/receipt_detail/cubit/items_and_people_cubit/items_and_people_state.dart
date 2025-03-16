part of 'items_and_people_cubit.dart';

@immutable
sealed class ItemsAndPeopleState {}

final class ItemsAndPeopleInitial extends ItemsAndPeopleState {}

final class ItemsAndPeopleUpdated extends ItemsAndPeopleState {
  final List<MenuItem> items;

  ItemsAndPeopleUpdated({required this.items});
}

final class AlreadyLinked extends ItemsAndPeopleState {}
