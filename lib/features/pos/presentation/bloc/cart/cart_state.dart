
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/item.dart';

@immutable
abstract class CartState extends Equatable {
  CartState([List props = const <dynamic>[]]) : super(props);
  Map<Item, num> get orderItems => {};
  num get totalPrice => 0;
  List<bool> get isDiscount => [];
  List<num> get quantities => [];
}

class ItemInitial extends CartState {}

class UpdateCart extends CartState {
  final Map<Item, num> order_items;
  final num price;
  final List<bool> isDis;
  @override
  Map<Item, num> get orderstate => order_items;
  @override
  List<bool> get isDiscount => isDis;
  UpdateCart({
    required this.order_items,
    required this.price,
    required this.isDis,
  }) : super([
          order_items,
          price,
          isDis,
        ]);
}

class CartError extends CartState {
  final String message;

  CartError({required this.message}) : super([message]);
}
