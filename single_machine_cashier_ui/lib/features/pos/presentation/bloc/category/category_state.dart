import 'package:flutter/foundation.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CategoryState  extends Equatable{
  CategoryState([List props = const <dynamic>[]]) : super(props);

  List<String> get categories =>null;

}

class Initial extends CategoryState {}

class CategoryInitial extends CategoryState {
  final List<String> categoriesNames;
  @override
  List<String> get categories => categoriesNames;
  
  CategoryInitial({
    @required this.categoriesNames,
  }
):super([categoriesNames]);
}


class CategoryItemsFound extends CategoryState {
  final List<String> categoriesNames;
    @override
  List<String> get categories => categoriesNames;

  CategoryItemsFound({
    @required this.categoriesNames,

  }):super([categoriesNames]);
}

class CategoryError extends CategoryState{
  final String message;

  CategoryError({@required this.message}) : super([message]);
}
