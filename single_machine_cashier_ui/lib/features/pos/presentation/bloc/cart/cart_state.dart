import 'package:single_machine_cashier_ui/features/pos/domain/entities/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ItemState  extends Equatable{
  ItemState([List props = const <dynamic>[]]) : super(props);
}

class ItemInitial extends ItemState {}


class Error extends ItemState{
  final String message;

  Error({@required this.message}) : super([message]);
}
