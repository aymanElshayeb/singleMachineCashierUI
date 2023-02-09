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

class AddToOrder extends CategoryEvent {
  final Item item;
  final int quantity;

  AddToOrder(this.item, this.quantity) : super([item, quantity]);
}
