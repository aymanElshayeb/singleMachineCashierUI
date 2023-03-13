
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/item.dart';

@immutable
abstract class ItemState extends Equatable {
  ItemState([List props = const <dynamic>[]]) : super(props);
}

class ItemsLoading extends ItemState {}

class ItemsLoaded extends ItemState {
  final List<Item> items;

  ItemsLoaded(this.items) : super([items]);
}

class ItemError extends ItemState {
  final String message;

  ItemError({required this.message}) : super([message]);
}
