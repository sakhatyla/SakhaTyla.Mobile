import 'package:flutter_bloc/flutter_bloc.dart';

import 'keyboard_event.dart';
import 'keyboard_state.dart';

class KeyboardBloc extends Bloc<KeyboardEvent, KeyboardBlocState> {
  KeyboardBloc() : super(KeyboardBlocState()) {
    on<KeyboardVisibilityChanged>((event, emit) {
      emit(KeyboardBlocState(isVisible: event.isVisible));
    });
  }
}
