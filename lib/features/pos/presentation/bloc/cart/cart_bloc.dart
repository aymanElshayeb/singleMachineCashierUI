import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/cart.dart';
import '../../../domain/entities/item.dart';
import '../../../domain/usecases/cart.dart';
import '../../../domain/usecases/items.dart';
import '../user/user_state.dart';
import 'cart_event.dart';
import 'cart_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String AUTHENTICATION_FAILURE_MESSAGE = 'Invalid password';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartActions cart;

  CartBloc({@required this.cart}) /*: assert(cart != null)*/;

  @override
  CartState get initialState => ItemInitial();

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is GetCartItems) {
    } else if (event is AddToOrder) {}
  }

  num getTotalPrice(Map<Item, num> order) {
    return 5;
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
