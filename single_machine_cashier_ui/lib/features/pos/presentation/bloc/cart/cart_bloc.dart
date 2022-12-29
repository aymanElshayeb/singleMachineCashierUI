import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/items.dart';
import '../user/user_state.dart';
import 'cart_event.dart';
import 'cart_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String AUTHENTICATION_FAILURE_MESSAGE = 'Invalid password';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final Items items;

  ItemBloc({@required this.items}): assert(items != null);


  @override
  ItemState get initialState => ItemInitial();

  @override
  Stream<ItemState> mapEventToState(ItemEvent event) async*{
    if (event != null ){
      ;
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
