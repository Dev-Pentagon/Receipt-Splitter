import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'preview_state.dart';

class PreviewCubit extends Cubit<PreviewState> {
  PreviewCubit() : super(PreviewInitial());
}
