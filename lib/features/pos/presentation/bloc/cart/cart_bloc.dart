import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:single_machine_cashier_ui/main.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/cart.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import 'package:logging/logging.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String AUTHENTICATION_FAILURE_MESSAGE = 'Invalid password';

class CartBloc extends Bloc<CartEvent, CartState> {
  final _log = Logger('CartBloc');
  CartBloc() : super(ItemInitial());

  @override
  CartState get initialState => ItemInitial();

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is SaveOrder) {
      List<double> quantities = [];
      event.items.values.forEach((element) {
        quantities.add(element.toDouble());
      });

      Cart cart = Cart(
          items: json.encode(event.items.keys.toList()),
          quantities: quantities);
      objectBox.cartBox.put(cart);
      for (var cart in objectBox.cartBox.getAll()) {
        _log.fine('${cart.items},${cart.quantities},id:${cart.id}');
      }
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
