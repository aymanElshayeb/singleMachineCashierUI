import 'package:flutter/foundation.dart';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/item.dart';

@immutable
abstract class CategoryState extends Equatable {
  CategoryState([List props = const <dynamic>[]]) : super(props);

  List<String> get categories => [];
  bool get gotitems => false;
  List<Item> get categoryitems => [];
  Map<Item, num>? get orderstate => {};
  List<Item> get eanitems => [];
  Map<Item, num> get subOrderState => {};
}

class Initial extends CategoryState {}

class CategoryInitial extends CategoryState {
  final List<String> categoriesNames;
  @override
  List<String> get categories => categoriesNames;

  CategoryInitial({
    required this.categoriesNames,
  }) : super([categoriesNames]);
}

class UpdateSubOrder extends CategoryState {
  final Map<Item, num> subOrder;
  @override
  Map<Item, num> get subOrderState => subOrder;

  UpdateSubOrder({
    required this.subOrder,
  }) : super([subOrder]);
}

class CategoryItemsFound extends CategoryState {
  final List<String> categoriesNames;
  final List<Item> categoriesitems;
  final bool boolitems;
  Map<Item, num>? orders;
  final List<Item> finalEanItems;
  final Map<Item, num> subOrder;
  @override
  Map<Item, num> get subOrderState => subOrder;

  @override
  bool get gotitems => boolitems;
  @override
  List<String> get categories => categoriesNames;
  @override
  List<Item> get categoryitems => categoriesitems;
  @override
  Map<Item, num>? get orderstate => orders;
  @override
  List<Item> get eanitems => finalEanItems;

  CategoryItemsFound(
      {required this.orders,
      required this.categoriesNames,
      required this.boolitems,
      required this.categoriesitems,
      required this.finalEanItems,
      required this.subOrder})
      : super([
          categoriesNames,
          boolitems,
          categoriesitems,
          orders,
          finalEanItems,
          subOrder
        ]);
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError({required this.message}) : super([message]);
}

class UpdateOrderState extends CategoryState {
  final Map<Item, num> order;
  final List<Item> items;
  final List<Item> finalEanItems;
  final Map<Item, num> subOrder;
  @override
  Map<Item, num> get subOrderState => subOrder;
  @override
  Map<Item, num> get orderstate => order;
  @override
  List<String> get categories => _mapCategoriesToList(items);
  @override
  List<Item> get categoryitems => items;
  @override
  bool get gotitems => true;
  @override
  List<Item> get eanitems => finalEanItems;

  UpdateOrderState(
      {required this.order,
      required this.items,
      required this.finalEanItems,
      required this.subOrder})
      : super([order, items, finalEanItems, subOrder]);
}

class getItems extends CategoryState {
  final Map<Item, num> order;
  final bool got_items;
  final List<Item> items;
  final List<Item> finalEanItems;
  @override
  Map<Item, num> get orderstate => order;
  @override
  List<String> get categories => _mapCategoriesToList(items);
  @override
  List<Item> get categoryitems => items;
  @override
  bool get gotitems => got_items;
  @override
  List<Item> get eanitems => finalEanItems;
  getItems({
    required this.finalEanItems,
    required this.order,
    required this.items,
    required this.got_items,
  }) : super([finalEanItems, order, items, got_items]);
}

List<String> _mapCategoriesToList(var categoryList) {
  List<String> categories = [];
  for (var category in categoryList) {
    categories.add(category.name);
  }
  return categories;
}
