import 'dart:async';
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

  CategoryBloc({@required this.categories, }): assert(categories != null);

  @override
  CategoryState get initialState => CategoryInitial(categoriesNames: const ["groceries","dairy"]);

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async*{
    if (event is GetCategoryItems){
      final failureOrCategory = await categories.getCategoryItems(event.id);
      yield failureOrCategory.fold((failure) => CategoryError(message:  _mapFailureToMessage(failure))
        ,(categoryList) => CategoryItemsFound(categoriesNames:_mapCategoriesToList(categoryList)),
      );
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
  List<String> _mapCategoriesToList(List<Item> categoryList) {
    List<String> categories=[];
    for (var category in categoryList) {
        categories.add(category.name);
    }
    return categories;
  }
  // Future<List<String>> _getAllCategories() async {
  //
  //   final failureOrCategory =await categories.getAllCategories();
  //   List<String> c;
  //   failureOrCategory.fold( (failure) => print("error")
  //     ,(categoryList) => c=_mapCategoriesToList(categoryList),
  //   );
  //  return c;
  // }
}


