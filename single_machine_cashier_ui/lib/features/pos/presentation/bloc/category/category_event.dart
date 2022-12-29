import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
@immutable
abstract class CategoryEvent extends Equatable {
  CategoryEvent([List props = const <dynamic>[]]) : super(props);
}

class GetCategoryItems extends CategoryEvent{
  final int id;
  GetCategoryItems(this.id):super([id]);

}