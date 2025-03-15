import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'items_and_people_state.dart';

class ItemsAndPeopleCubit extends Cubit<ItemsAndPeopleState> {
  ItemsAndPeopleCubit() : super(ItemsAndPeopleInitial());
}
