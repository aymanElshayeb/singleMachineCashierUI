import 'package:single_machine_cashier_ui/features/pos/domain/entities/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserState extends Equatable {
  List<User> get users => [];
  User get currentUser => User();
  UserState([List props = const <dynamic>[]]) : super(props);
}

class UserInitial extends UserState {}

class Authenticated extends UserState {
  final User current;
  @override
  User get currentUser => current;
  Authenticated({@required this.current}) : super([current]);
}

class AuthenticatedAgain extends UserState {
  final User current;
  @override
  User get currentUser => current;
  AuthenticatedAgain({@required this.current}) : super([current]);
}

class UpdateUsers extends UserState {
  final List<User> our_users;
  @override
  List<User> get users => our_users;

  UpdateUsers({@required this.our_users}) : super([our_users]);
}

class Error extends UserState {
  final String message;

  Error({@required this.message}) : super([message]);
}
