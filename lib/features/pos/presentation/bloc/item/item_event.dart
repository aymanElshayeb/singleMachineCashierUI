import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ItemEvent extends Equatable {
  const ItemEvent();
  @override
  List<Object?> get props => [];
}

class LoadItems extends ItemEvent {
  final String categoryId;

  const LoadItems(this.categoryId);
}
