import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/item.dart';

@immutable
abstract class ItemState extends Equatable {
  const ItemState();
  @override
  List<Object?> get props => [];
}

class ItemsInitial extends ItemState {}

class ItemsLoading extends ItemState {}

class ItemsLoaded extends ItemState {
  final List<Item> items;

  ItemsLoaded(this.items);
}
class SessionEndedState extends ItemState {}

class ItemError extends ItemState {
  final String message;

  ItemError({required this.message});
}
