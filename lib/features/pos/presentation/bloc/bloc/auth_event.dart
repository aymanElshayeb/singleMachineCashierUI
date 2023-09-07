part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInEvent extends AuthEvent {
  final String password;
  const SignInEvent({required this.password});
}

class SignOutEvent extends AuthEvent {}
