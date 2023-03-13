import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/item.dart';

@immutable
abstract class CartEvent extends Equatable {
  CartEvent([List props = const <dynamic>[]]) : super(props);
}

class PrintOrderRecipt extends CartEvent {
  final Map<Item, num> items;

  PrintOrderRecipt({required this.items});
}

class SaveOrder extends CartEvent {
  final Map<Item, num> items;
  SaveOrder({required this.items});
}
