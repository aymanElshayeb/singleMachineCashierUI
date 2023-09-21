part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final User currentUser;
  const AuthState({required this.currentUser});

  @override
  List<Object> get props => [currentUser];
  factory AuthState.initial() {
    return AuthState(
      currentUser: User.empty(),
    );
  }
}

class UserSignedIn extends AuthState {
  final User user;

  const UserSignedIn(this.user) : super(currentUser: user);

  @override
  List<Object> get props => [user];
}

class UserErrorState extends AuthState {
  final String errorMessage;

  const UserErrorState(
      {required this.errorMessage, required super.currentUser});
  @override
  List<Object> get props => [errorMessage];
}

class UserSignedOut extends AuthState {
  const UserSignedOut({required super.currentUser});

  @override
  List<Object> get props => [];
}
