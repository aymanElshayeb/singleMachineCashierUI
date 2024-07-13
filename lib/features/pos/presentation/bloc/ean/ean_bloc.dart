import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/items.dart';

part 'ean_event.dart';
part 'ean_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String AUTHENTICATION_FAILURE_MESSAGE = 'Invalid password';

class EanBloc extends Bloc<EanEvent, EanState> {
  final Items items;
  EanBloc({required this.items}) : super(EanInitial()) {
    on<LoadEanItems>(_onLoadEanItems);
    on<EmptyEan>(_onEmptyEan);
  }

  FutureOr<void> _onLoadEanItems(
      LoadEanItems event, Emitter<EanState> emit) async {
    try {
      emit(EanItemsLoading());
      final response = await items.getItemsByEan(keyWord: event.keyWord);
      response.fold((failure) {
        if (failure is AuthenticationFailure) {
          emit(SessionEndedState());
        } else {
          emit(ItemError(message: _mapFailureToMessage(failure)));
        }
      }, (items) => emit(EanItemsLoaded(items)));
    } catch (e) {
      emit(ItemError(message: 'Error fetching items: $e'));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case AuthenticationFailure:
        return AUTHENTICATION_FAILURE_MESSAGE;
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }

  FutureOr<void> _onEmptyEan(EmptyEan event, Emitter<EanState> emit) {
    emit(EanInitial());
  }
}
