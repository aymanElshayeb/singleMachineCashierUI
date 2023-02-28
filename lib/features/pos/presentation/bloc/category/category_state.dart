import 'package:flutter/foundation.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/user.dart';

import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CategoryState extends Equatable {
  CategoryState([List props = const <dynamic>[]]) : super(props);

  List<String> get categories => [];
  bool get gotitems => null;
  List<Item> get categoryitems => [];
  Map<Item, num> get orderstate => {};
  List<Item> get eanitems => [];
}

class Initial extends CategoryState {}

class CategoryInitial extends CategoryState {
  final List<String> categoriesNames;
  @override
  List<String> get categories => categoriesNames;

  CategoryInitial({
    @required this.categoriesNames,
  }) : super([categoriesNames]);
}

class CategoryItemsFound extends CategoryState {
  final List<String> categoriesNames;
  final List<Item> categoriesitems;
  final bool boolitems;
  Map<Item, num> orders;
  final List<Item> finalEanItems;

  @override
  bool get gotitems => boolitems;
  @override
  List<String> get categories => categoriesNames;
  @override
  List<Item> get categoryitems => categoriesitems;
  @override
  Map<Item, num> get orderstate => orders;
  @override
  List<Item> get eanitems => finalEanItems;

  CategoryItemsFound(
      {@required this.orders,
      @required this.categoriesNames,
      @required this.boolitems,
      @required this.categoriesitems,
      @required this.finalEanItems})
      : super([
          categoriesNames,
          boolitems,
          categoriesitems,
          orders,
          finalEanItems
        ]);
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError({@required this.message}) : super([message]);
}

class UpdateOrderState extends CategoryState {
  final Map<Item, num> order;
  final List<Item> items;
  final List<Item> finalEanItems;
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
      {@required this.order,
      @required this.items,
      @required this.finalEanItems})
      : super([order, items, finalEanItems]);
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
    @required this.finalEanItems,
    @required this.order,
    @required this.items,
    @required this.got_items,
  }) : super([finalEanItems, order, items, got_items]);
}

List<String> _mapCategoriesToList(var categoryList) {
  List<String> categories = [];
  for (var category in categoryList) {
    categories.add(category.name);
  }
  return categories;
}
