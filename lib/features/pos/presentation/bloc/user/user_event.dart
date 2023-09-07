import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/user.dart';

@immutable
abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object> get props => [];
}

class AuthenticateUserEvent extends UserEvent {
  final String password;
  const AuthenticateUserEvent(this.password);
}

class SecondAuthenticate extends UserEvent {
  final String password;
  const SecondAuthenticate(this.password);
}

class GetAllUsers extends UserEvent {}

class AddUser extends UserEvent {
  final User user;

  const AddUser(this.user);
}
