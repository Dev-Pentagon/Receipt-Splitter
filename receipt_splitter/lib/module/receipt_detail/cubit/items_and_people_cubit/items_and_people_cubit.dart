import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'items_and_people_state.dart';

class ItemsAndPeopleCubit extends Cubit<ItemsAndPeopleState> {
  ItemsAndPeopleCubit() : super(ItemsAndPeopleInitial());
}
