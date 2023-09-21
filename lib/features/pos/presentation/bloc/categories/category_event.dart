part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class FetchCategoriesEvent extends CategoryEvent {}

class NavigateToItemsEvent extends CategoryEvent {
  final String categoryId;

  const NavigateToItemsEvent({required this.categoryId});
}

class NavigateToCategoriesEvent extends CategoryEvent {}
