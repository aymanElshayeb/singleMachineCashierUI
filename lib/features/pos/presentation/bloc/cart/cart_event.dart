import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/item.dart';

@immutable
abstract class CartEvent extends Equatable {
  CartEvent([List props = const <dynamic>[]]) : super(props);
}

class UpdateOrderEvent extends CartEvent {
  final Item item;
  final List<Item> items;

  UpdateOrderEvent(this.item, this.items) : super([item, items]);
}

class GetCartItems extends CartEvent {
  final Map<Item, num> orderstate;

  GetCartItems(this.orderstate) : super([orderstate]);
}

class SubtractFromOrder extends CartEvent {
  final Item item;
  SubtractFromOrder(this.item) : super([item]);
}

class DeleteFromOrder extends CartEvent {
  final Item item;
  DeleteFromOrder(this.item) : super([item]);
}

class AddToOrder extends CartEvent {
  final Item item;
  final num quantity;

  AddToOrder(this.item, this.quantity) : super([item, quantity]);
}
