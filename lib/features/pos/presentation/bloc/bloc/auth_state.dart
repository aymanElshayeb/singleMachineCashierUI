part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class LoadingAuthState extends AuthState {}

class Authenticated extends AuthState {}

class Unauthenticated extends AuthState {}

class UserErrorState extends AuthState {
  final String errorMessage;

  const UserErrorState({required this.errorMessage});
}
