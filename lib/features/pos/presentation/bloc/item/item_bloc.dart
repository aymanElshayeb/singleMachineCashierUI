import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/items.dart';
import 'item_event.dart';
import 'item_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String AUTHENTICATION_FAILURE_MESSAGE = 'Invalid password';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final Items items;

  ItemBloc({required this.items}) : super(ItemsInitial()) {
    on<LoadItems>(_onLoadItems);
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

  FutureOr<void> _onLoadItems(LoadItems event, Emitter<ItemState> emit) async {
    try {
      emit(ItemsLoading());
      final response =
          await items.getItemsByCategory(categoryId: event.categoryId);
      response.fold(
          (failure) => emit(ItemError(message: _mapFailureToMessage(failure))),
          (items) => emit(ItemsLoaded(items)));
    } catch (e) {
      emit(ItemError(message: 'Error fetching users: $e'));
    }
  }
}
