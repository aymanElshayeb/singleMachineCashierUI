part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

final class CategoryInitial extends CategoryState {}

class CategoriesLoadingState extends CategoryState {}

class CategoriesLoadedState extends CategoryState {
  final List<Category> categories;

  const CategoriesLoadedState({required this.categories});
}

class ErrorState extends CategoryState {
  final String errorMessage;
  const ErrorState({required this.errorMessage});
}

class NavigateToItemsState extends CategoryState {
  final String categoryId;

  const NavigateToItemsState({required this.categoryId});
}

class NavigateToCategoriesState extends CategoryState {}
