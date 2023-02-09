import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
@immutable
abstract class ItemEvent extends Equatable {
  ItemEvent([List props = const <dynamic>[]]) : super(props);
}

