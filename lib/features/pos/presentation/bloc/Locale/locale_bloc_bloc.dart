import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'locale_bloc_event.dart';
part 'locale_bloc_state.dart';

class LocaleBlocBloc extends Bloc<LocaleBlocEvent, LocaleBlocState> {
  LocaleBlocBloc(LocaleBlocState initialState)
      : super(LocaleBlocState.initial()) {
    on<LoadLanguage>(_onLoadLanguage);
  }

  FutureOr<void> _onLoadLanguage(
      LoadLanguage event, Emitter<LocaleBlocState> emit) {
    emit(LocaleBlocState(locale: event.locale));
  }
}
