import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'preview_state.dart';

class PreviewCubit extends Cubit<PreviewState> {
  PreviewCubit() : super(PreviewInitial());
}
