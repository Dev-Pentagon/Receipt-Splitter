import 'package:flutter_bloc/flutter_bloc.dart';

class FabCubit extends Cubit<bool> {
  FabCubit() : super(false);

  void toggle() => emit(!state);
}
