import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/authenticate_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String AUTHENTICATION_FAILURE_MESSAGE = 'Invalid password';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticateUser _authenticateUser;
  AuthBloc({required AuthenticateUser authenticateUser})
      : _authenticateUser = authenticateUser,
        super(Unauthenticated()) {
    on<SignInEvent>(_onSignInEvent);
    on<SignOutEvent>(_onSignOutEvent);
  }

  FutureOr<void> _onSignInEvent(
      SignInEvent event, Emitter<AuthState> emit) async {
    try {
      emit(LoadingAuthState());
      final response = await _authenticateUser.authenticate(event.password);
      response.fold(
          (errorMessage) => emit(UserErrorState(
                errorMessage: _mapFailureToMessage(errorMessage),
              )),
          (user) => emit(Authenticated()));
    } catch (e) {
      emit(UserErrorState(
        errorMessage: 'Error fetching users: $e',
      ));
    }
  }

  FutureOr<void> _onSignOutEvent(SignOutEvent event, Emitter<AuthState> emit) {}
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case AuthenticationFailure:
        return AUTHENTICATION_FAILURE_MESSAGE;
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
