part of 'ean_bloc.dart';

sealed class EanState extends Equatable {
  const EanState();

  @override
  List<Object> get props => [];
}

final class EanInitial extends EanState {}

final class EanItemsLoading extends EanState {}

class EanItemsLoaded extends EanState {
  final List<Item> items;

  const EanItemsLoaded(this.items);
}

class ItemError extends EanState {
  final String message;

  const ItemError({required this.message});
}
