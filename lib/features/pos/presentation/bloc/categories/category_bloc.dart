import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/category.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/categories.dart';

part 'category_event.dart';
part 'category_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String AUTHENTICATION_FAILURE_MESSAGE = '''Your session has ended.
Please log in again to continue accessing the application.
If you believe this is an error, please check your internet connection and try again.''';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final Categories categories;
  CategoryBloc({required this.categories}) : super(CategoryInitial()) {
    on<FetchCategoriesEvent>(_onFetchCategoriesEvent);
    on<NavigateToCategoriesEvent>(_onNavigateToCategoriesEvent);
    on<NavigateToItemsEvent>(_onNavigateToItemsEvent);
  }

  FutureOr<void> _onFetchCategoriesEvent(
      FetchCategoriesEvent event, Emitter<CategoryState> emit) async {
    try {
      emit(NavigateToCategoriesState());
      emit(CategoriesLoadingState());
      final response = await categories.getAllCategories();
      response.fold((failure) {
        if (failure is AuthenticationFailure) {
          emit(SessionEndedState());
        }else{
          emit(ErrorState(errorMessage: _mapFailureToMessage(failure)));
        }
        
      }, (categories) => emit(CategoriesLoadedState(categories: categories)));
    } catch (e) {
      emit(ErrorState(errorMessage: 'Error fetching categories: $e'));
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

  FutureOr<void> _onNavigateToCategoriesEvent(
      NavigateToCategoriesEvent event, Emitter<CategoryState> emit) {
    emit(NavigateToCategoriesState());
  }

  FutureOr<void> _onNavigateToItemsEvent(
      NavigateToItemsEvent event, Emitter<CategoryState> emit) {
    emit(NavigateToItemsState(categoryId: event.categoryId));
  }
}
