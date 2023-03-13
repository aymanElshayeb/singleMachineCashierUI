import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ItemEvent extends Equatable {
  ItemEvent([List props = const <dynamic>[]]) : super(props);
}

class LoadItems extends ItemEvent {
  final int categoryId;

  LoadItems(this.categoryId) : super([categoryId]);
}
