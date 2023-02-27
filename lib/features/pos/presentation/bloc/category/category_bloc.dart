import 'dart:async';
//import 'dart:html';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/category.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/categories.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/item.dart';
import 'category_event.dart';
import 'category_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String AUTHENTICATION_FAILURE_MESSAGE = 'Invalid password';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final Categories categories;

  CategoryBloc({
    @required this.categories,
  }) /*: assert(categories != null)*/;

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
            finalEanItems: state.eanitems),
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
            finalEanItems: state.eanitems),
      );
    } else if (event is UpdateOrderEvent) {
      Map<Item, num> orders = {};
      orders = state.orderstate;
      if (orders.containsKey(event.item)) {
        orders.update(event.item, (value) => value + 1);
      } else {
        orders[event.item] = 1;
      }

      yield UpdateOrderState(
          order: orders,
          items: state.categoryitems,
          finalEanItems: state.eanitems);
      yield CategoryItemsFound(
          categoriesNames: _mapCategoriesToList(state.categoryitems),
          boolitems: true,
          categoriesitems: state.categoryitems,
          orders: state.orderstate,
          finalEanItems: state.eanitems);
    } else if (event is AddToOrder) {
      Map<Item, num> orders = {};
      orders = state.orderstate;
      orders[event.item] = event.quantity;
      yield UpdateOrderState(order: orders, items: state.categoryitems);
      yield CategoryItemsFound(
          categoriesNames: _mapCategoriesToList(state.categoryitems),
          boolitems: state.gotitems,
          categoriesitems: state.categoryitems,
          orders: state.orderstate,
          finalEanItems: []);
    } else if (event is GetEAN) {
      final failureOrItems = await categories.execGetEanItem(event.ean);
      yield failureOrItems.fold(
          (failure) => CategoryError(message: _mapFailureToMessage(failure)),
          (itemsList) => getItems(
              finalEanItems: itemsList,
              got_items: state.gotitems,
              items: state.categoryitems,
              order: state.orderstate));
    } else if (event is SubtractFromOrder) {
      Map<Item, num> orders = {};
      orders = state.orderstate;
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
            finalEanItems: state.eanitems);
        yield CategoryItemsFound(
            categoriesNames: _mapCategoriesToList(state.categoryitems),
            boolitems: state.gotitems,
            categoriesitems: state.categoryitems,
            orders: state.orderstate,
            finalEanItems: state.eanitems);
      }
    } else if (event is DeleteFromOrder) {
      Map<Item, num> orders = {};
      orders = state.orderstate;
      orders.remove(event.item);
      yield UpdateOrderState(
          order: orders,
          items: state.categoryitems,
          finalEanItems: state.eanitems);
      yield CategoryItemsFound(
          categoriesNames: _mapCategoriesToList(state.categoryitems),
          boolitems: true,
          categoriesitems: state.categoryitems,
          orders: state.orderstate,
          finalEanItems: state.eanitems);
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
