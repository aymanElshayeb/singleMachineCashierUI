import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/item.dart';

@immutable
abstract class CategoryEvent extends Equatable {
  CategoryEvent([List props = const <dynamic>[]]) : super(props);
}

class InitEvent extends CategoryEvent {}

class GetCategoryItems extends CategoryEvent {
  final int id;
  GetCategoryItems(
    this.id,
  ) : super([id]);
}

class GetCategoryNumber extends CategoryEvent {}

class UpdateOrderEvent extends CategoryEvent {
  final Item item;
  final List<Item> items;

  UpdateOrderEvent(this.item, this.items) : super([item, items]);
}

class SubtractFromOrder extends CategoryEvent {
  final Item item;
  SubtractFromOrder(this.item) : super([item]);
}

class SubtractFromSubOrder extends CategoryEvent {
  final Item item;
  SubtractFromSubOrder(this.item) : super([item]);
}

class DeleteFromSubOrder extends CategoryEvent {
  final Item item;
  DeleteFromSubOrder(this.item) : super([item]);
}

class FinishOrder extends CategoryEvent {
  final bool isOrder;
  FinishOrder(this.isOrder) : super([isOrder]);
}

class AddToSubOrder extends CategoryEvent {
  final Item item;
  final num quantity;

  AddToSubOrder(this.item, this.quantity) : super([item, quantity]);
}

class DeleteFromOrder extends CategoryEvent {
  final Item item;
  DeleteFromOrder(this.item) : super([item]);
}

class CancelOrder extends CategoryEvent {}

class AddToOrder extends CategoryEvent {
  final Item item;
  final num quantity;

  AddToOrder(this.item, this.quantity) : super([item, quantity]);
}

class GetEAN extends CategoryEvent {
  final String ean;
  GetEAN(
    this.ean,
  ) : super([ean]);
}
