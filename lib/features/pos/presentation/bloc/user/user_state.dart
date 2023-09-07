import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/user.dart';

@immutable
abstract class UserState extends Equatable {
  List<User> get users => [];
  User get currentUser =>
      User(fullname: '', role: '', password: '', userName: '');
  const UserState();
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class Authenticated extends UserState {
  final User current;
  @override
  User get currentUser => current;
  const Authenticated({required this.current});
}

class UsersLoading extends UserState {}

class AuthenticatedAgain extends UserState {
  final User current;
  @override
  User get currentUser => current;
  const AuthenticatedAgain({required this.current});
}

class UpdateUsers extends UserState {
  final List<User> our_users;
  @override
  List<User> get users => our_users;

  const UpdateUsers({required this.our_users});
}

class Error extends UserState {
  final String message;

  const Error({required this.message});
}
