import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:single_machine_cashier_ui/features/pos/data/repositories/auth_repository_impl.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthState.initial()) {
    on<SignOutUser>(_onSignOutUser);
    on<GoogleSignInUser>(_onGoogleSignInUser);
    on<EmailSignInUser>(_onEmailSignInUser);
  }

  FutureOr<void> _onSignOutUser(
      SignOutUser event, Emitter<AuthState> emit) async {
    try {
      final response = await _authRepository.signOutUser();
      response.fold(
          (errorMessage) => emit(UserErrorState(
              errorMessage: errorMessage, currentUser: state.currentUser)),
          (user) => emit(UserSignedOut(currentUser: User.empty())));
    } catch (e) {
      emit(UserErrorState(
          errorMessage: 'Error fetching users: $e',
          currentUser: state.currentUser));
    }
  }

  FutureOr<void> _onGoogleSignInUser(
      GoogleSignInUser event, Emitter<AuthState> emit) async {
    try {
      final response = await _authRepository.googleSignInUser();
      response.fold(
          (errorMessage) => emit(UserErrorState(
              errorMessage: errorMessage, currentUser: state.currentUser)),
          (user) => emit(UserSignedIn(user)));
    } catch (e) {
      emit(UserErrorState(
          errorMessage: 'Error fetching users: $e',
          currentUser: state.currentUser));
    }
  }

  FutureOr<void> _onEmailSignInUser(
      EmailSignInUser event, Emitter<AuthState> emit) async {
    try {
      final response =
          await _authRepository.emailSignInUser(event.email, event.password);
      response.fold(
          (errorMessage) => emit(UserErrorState(
              errorMessage: errorMessage, currentUser: state.currentUser)),
          (user) => emit(UserSignedIn(user)));
    } catch (e) {
      emit(UserErrorState(
          errorMessage: 'Error fetching users: $e',
          currentUser: state.currentUser));
    }
  }
}
