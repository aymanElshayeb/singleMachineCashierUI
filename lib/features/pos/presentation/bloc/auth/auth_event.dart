part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class GoogleSignInUser extends AuthEvent {}

class EmailSignInUser extends AuthEvent {
  final String email;
  final String password;

  const EmailSignInUser({required this.email, required this.password});
}

class SignOutUser extends AuthEvent {
  @override
  List<Object> get props => [];
}
