import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/user.dart';

@immutable
abstract class UserEvent extends Equatable {
  UserEvent([List props = const <dynamic>[]]) : super(props);
}

class AuthenticateUserEvent extends UserEvent {
  final String password;
  AuthenticateUserEvent(this.password) : super([password]);
}

class GetAllUsers extends UserEvent {}

class AddUser extends UserEvent {
  final User user;

  AddUser(this.user) : super([user]);
}
