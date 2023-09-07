import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/item.dart';
import '../../../domain/usecases/categories.dart';
import 'category_event.dart';
import 'category_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String AUTHENTICATION_FAILURE_MESSAGE = 'Invalid password';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final Categories categories;

  CategoryBloc({
    required this.categories,
  }) : super(Initial());

  @override
  CategoryState get initialState => Initial();

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is GetCategoryItems) {
      final failureOrCategory = await categories.getCategoryItems(event.id);
      yield failureOrCategory.fold(
        (failure) => CategoryError(message: _mapFailureToMessage(failure)),
        (categoryList) => CategoryItemsFound(
            categoriesNames: _mapCategoriesToList(categoryList),
            boolitems: true,
            categoriesitems: categoryList,
            orders: state.orderstate,
            finalEanItems: state.eanitems,
            subOrder: state.subOrderState),
      );
    } else if (event is InitEvent) {
      final failureOrCategory = await categories.getAllCategories();
      yield failureOrCategory.fold(
        (failure) => CategoryError(message: _mapFailureToMessage(failure)),
        (categoryList) => CategoryItemsFound(
            categoriesNames: _mapCategoriesToList(categoryList),
            boolitems: false,
            categoriesitems: [],
            orders: state.orderstate,
            finalEanItems: state.eanitems,
            subOrder: state.subOrderState),
      );
    } else if (event is UpdateOrderEvent) {
      Map<Item, num>? orders = {};
      orders = state.orderstate;
      if (orders!.containsKey(event.item)) {
        orders.update(event.item, (value) => value + 1);
      } else {
        orders[event.item] = 1;
      }

      yield UpdateOrderState(
          order: orders,
          items: state.categoryitems,
          finalEanItems: state.eanitems,
          subOrder: state.subOrderState);
      yield CategoryItemsFound(
          categoriesNames: _mapCategoriesToList(state.categoryitems),
          boolitems: true,
          categoriesitems: state.categoryitems,
          orders: state.orderstate,
          finalEanItems: state.eanitems,
          subOrder: state.subOrderState);
    } else if (event is AddToOrder) {
      Map<Item, num> orders = {};
      orders = state.orderstate!;

      if (orders.containsKey(event.item)) {
        var a = event.quantity!;
        var b = orders[event.item]!;
        var c = a + b;
        orders[event.item] = c;
      } else {
        orders[event.item] = event.quantity!;
      }

      yield UpdateOrderState(
          order: orders,
          items: state.categoryitems,
          subOrder: state.subOrderState,
          finalEanItems: state.eanitems);
      yield CategoryItemsFound(
          categoriesNames: _mapCategoriesToList(state.categoryitems),
          boolitems: state.gotitems,
          categoriesitems: state.categoryitems,
          orders: orders,
          finalEanItems: [],
          subOrder: state.subOrderState);
    } else if (event is GetEAN) {
      final failureOrItems = await categories.execGetEanItem(event.ean);
      yield failureOrItems.fold(
          (failure) => CategoryError(message: _mapFailureToMessage(failure)),
          (itemsList) => getItems(
              finalEanItems: itemsList,
              got_items: state.gotitems,
              items: state.categoryitems,
              order: state.orderstate!));
    } else if (event is SubtractFromOrder) {
      Map<Item, num> orders = {};
      orders = state.orderstate!;
      if (orders.containsKey(event.item)) {
        orders.update(event.item, (value) {
          if (value > 1)
            return value - 1;
          else
            return value;
        });
        yield UpdateOrderState(
            order: orders,
            items: state.categoryitems,
            finalEanItems: state.eanitems,
            subOrder: state.subOrderState);
        yield CategoryItemsFound(
            categoriesNames: _mapCategoriesToList(state.categoryitems),
            boolitems: state.gotitems,
            categoriesitems: state.categoryitems,
            orders: state.orderstate,
            finalEanItems: state.eanitems,
            subOrder: state.subOrderState);
      }
    } else if (event is DeleteFromOrder) {
      Map<Item, num> orders = {};
      orders = state.orderstate!;
      List<Item> toRemove = [];
      if (event.item.name.contains('Discount')) {
        orders.remove(event.item);
      } else {
        orders.forEach((key, value) {
          if (key.name.contains(event.item.name)) {
            toRemove.add(key);
          }
        });
        orders.removeWhere((key, value) => toRemove.contains(key));
      }

      yield UpdateOrderState(
          order: orders,
          items: state.categoryitems,
          finalEanItems: state.eanitems,
          subOrder: state.subOrderState);
      yield CategoryItemsFound(
          categoriesNames: _mapCategoriesToList(state.categoryitems),
          boolitems: true,
          categoriesitems: state.categoryitems,
          orders: state.orderstate,
          finalEanItems: state.eanitems,
          subOrder: state.subOrderState);
    } else if (event is AddToSubOrder) {
      Map<Item, num> suborder = {};
      suborder = state.subOrderState;
      if (suborder.containsKey(event.item)) {
        var a = event.quantity;
        var b = suborder[event.item]!;
        var c = a + b;
        suborder[event.item] = c;
      } else {
        suborder[event.item] = event.quantity;
      }

      yield UpdateOrderState(
          order: state.orderstate!,
          items: state.categoryitems,
          subOrder: state.subOrderState,
          finalEanItems: state.eanitems);
      yield CategoryItemsFound(
          categoriesNames: _mapCategoriesToList(state.categoryitems),
          boolitems: state.gotitems,
          categoriesitems: state.categoryitems,
          orders: state.orderstate,
          finalEanItems: [],
          subOrder: suborder);
    } else if (event is DeleteFromSubOrder) {
      Map<Item, num> orders = {};
      orders = state.subOrderState;
      orders.remove(event.item);
      List<Item> toRemove = [];
      orders.forEach((key, value) {
        if (key.name.contains(event.item.name)) {
          toRemove.add(key);
        }
      });
      orders.removeWhere((key, value) => toRemove.contains(key));

      yield UpdateOrderState(
          order: state.orderstate!,
          items: state.categoryitems,
          finalEanItems: state.eanitems,
          subOrder: orders);
      yield CategoryItemsFound(
          categoriesNames: _mapCategoriesToList(state.categoryitems),
          boolitems: true,
          categoriesitems: state.categoryitems,
          orders: state.orderstate,
          finalEanItems: state.eanitems,
          subOrder: orders);
    } else if (event is SubtractFromSubOrder) {
      Map<Item, num> orders = {};
      orders = state.subOrderState;
      if (orders.containsKey(event.item)) {
        orders.update(event.item, (value) {
          if (value > 1)
            return value - 1;
          else
            return value;
        });
        yield UpdateOrderState(
            order: state.orderstate!,
            items: state.categoryitems,
            finalEanItems: state.eanitems,
            subOrder: orders);
        yield CategoryItemsFound(
            categoriesNames: _mapCategoriesToList(state.categoryitems),
            boolitems: state.gotitems,
            categoriesitems: state.categoryitems,
            orders: state.orderstate,
            finalEanItems: state.eanitems,
            subOrder: orders);
      }
    } else if (event is FinishOrder) {
      if (event.isOrder) {
        yield UpdateOrderState(
            order: {},
            items: state.categoryitems,
            finalEanItems: state.eanitems,
            subOrder: state.subOrderState);
        yield CategoryItemsFound(
            categoriesNames: _mapCategoriesToList(state.categoryitems),
            boolitems: state.gotitems,
            categoriesitems: state.categoryitems,
            orders: {},
            finalEanItems: state.eanitems,
            subOrder: state.subOrderState);
      } else {
        yield UpdateOrderState(
            order: state.orderstate!,
            items: state.categoryitems,
            finalEanItems: state.eanitems,
            subOrder: {});
        yield CategoryItemsFound(
            categoriesNames: _mapCategoriesToList(state.categoryitems),
            boolitems: state.gotitems,
            categoriesitems: state.categoryitems,
            orders: state.orderstate,
            finalEanItems: state.eanitems,
            subOrder: {});
      }
    } else if (event is CancelOrder) {
      yield UpdateOrderState(
          order: {},
          items: state.categoryitems,
          finalEanItems: [],
          subOrder: {});
      yield CategoryItemsFound(
          categoriesNames: _mapCategoriesToList(state.categoryitems),
          boolitems: state.gotitems,
          categoriesitems: state.categoryitems,
          orders: {},
          finalEanItems: [],
          subOrder: {});
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

  List<String> _mapCategoriesToList(var categoryList) {
    List<String> categories = [];
    for (var category in categoryList) {
      categories.add(category.name);
    }
    return categories;
  }
}
