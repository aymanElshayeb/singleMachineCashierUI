import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/item.dart';

@immutable
abstract class CategoryEvent extends Equatable {
  CategoryEvent();
  @override
  List<Object> get props => [];
}

class InitEvent extends CategoryEvent {}

class GetCategoryItems extends CategoryEvent {
  final int id;
  GetCategoryItems(
    this.id,
  );
}

class GetCategoryNumber extends CategoryEvent {}

class UpdateOrderEvent extends CategoryEvent {
  final Item item;
  final List<Item> items;

  UpdateOrderEvent(this.item, this.items);
}

class SubtractFromOrder extends CategoryEvent {
  final Item item;
  SubtractFromOrder(this.item);
}

class SubtractFromSubOrder extends CategoryEvent {
  final Item item;
  SubtractFromSubOrder(this.item);
}

class DeleteFromSubOrder extends CategoryEvent {
  final Item item;
  DeleteFromSubOrder(this.item);
}

class FinishOrder extends CategoryEvent {
  final bool isOrder;
  FinishOrder(this.isOrder);
}

class AddToSubOrder extends CategoryEvent {
  final Item item;
  final num quantity;

  AddToSubOrder(this.item, this.quantity);
}

class DeleteFromOrder extends CategoryEvent {
  final Item item;
  DeleteFromOrder(this.item);
}

class CancelOrder extends CategoryEvent {}

class AddToOrder extends CategoryEvent {
  final Item item;
  final num? quantity;

  AddToOrder(this.item, this.quantity);
}

class GetEAN extends CategoryEvent {
  final String ean;
  GetEAN(
    this.ean,
  );
}
