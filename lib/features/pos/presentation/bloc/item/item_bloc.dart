import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/items.dart';
import '../user/user_state.dart';
import 'item_event.dart';
import 'item_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String AUTHENTICATION_FAILURE_MESSAGE = 'Invalid password';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final Items items;

  ItemBloc({required this.items}) : super(ItemsLoading());

  @override
  ItemState get initialState => ItemsLoading();

  @override
  Stream<ItemState> mapEventToState(ItemEvent event) async* {
    if (event is LoadItems) {
      yield ItemsLoading();
      final failureOrCategory =
          await items.getItemsByCategory(event.categoryId);
      yield failureOrCategory.fold(
        (failure) => ItemError(message: _mapFailureToMessage(failure)),
        (itemList) => ItemsLoaded(itemList),
      );
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
}
