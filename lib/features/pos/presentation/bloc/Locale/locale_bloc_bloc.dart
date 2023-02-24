import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'locale_bloc_event.dart';
part 'locale_bloc_state.dart';

class LocaleBlocBloc extends Bloc<LocaleBlocEvent, LocaleBlocState> {
  LocaleBlocBloc(LocaleBlocState initialState) : super();

  @override
  // TODO: implement initialState
  LocaleBlocState get initialState => LocaleBlocState.initial();

  @override
  Stream<LocaleBlocState> mapEventToState(LocaleBlocEvent event) async* {
    if (event is LoadLanguage) {
      yield LocaleBlocState(locale: event.locale);
    }
  }
}
