import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/item.dart';

@immutable
abstract class CartEvent extends Equatable {
  CartEvent();
  @override
  List<Object> get props => [];
}

class SaveOrder extends CartEvent {
  final Map<Item, num> items;
  SaveOrder({required this.items});
}
