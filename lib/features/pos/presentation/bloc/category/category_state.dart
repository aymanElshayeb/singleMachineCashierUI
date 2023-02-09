import 'package:flutter/foundation.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/user.dart';

import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CategoryState extends Equatable {
  CategoryState([List props = const <dynamic>[]]) : super(props);

  List<String> get categories => null;
  bool get gotitems => null;
  List<Item> get categoryitems => null;
  Map<Item, int> get orderstate => {};
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
  Map<Item, int> orders;

  @override
  bool get gotitems => boolitems;
  @override
  List<String> get categories => categoriesNames;
  @override
  List<Item> get categoryitems => categoriesitems;
  @override
  Map<Item, int> get orderstate => orders;

  CategoryItemsFound({
    @required this.orders,
    @required this.categoriesNames,
    @required this.boolitems,
    @required this.categoriesitems,
  }) : super([categoriesNames, boolitems, categoriesitems, orders]);
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError({@required this.message}) : super([message]);
}

class UpdateOrderState extends CategoryState {
  final Map<Item, int> order;
  final List<Item> items;
  @override
  Map<Item, int> get orderstate => order;
  @override
  List<String> get categories => _mapCategoriesToList(items);
  @override
  List<Item> get categoryitems => items;
  @override
  bool get gotitems => true;

  UpdateOrderState({@required this.order, @required this.items})
      : super([order, items]);
}

List<String> _mapCategoriesToList(var categoryList) {
  List<String> categories = [];
  for (var category in categoryList) {
    categories.add(category.name);
  }
  return categories;
}
