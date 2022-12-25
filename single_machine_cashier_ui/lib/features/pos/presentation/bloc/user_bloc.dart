import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/user_event.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/user_state.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/authenticate_user.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String AUTHENTICATION_FAILURE_MESSAGE = 'Invalid password';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AuthenticateUser authenticateUser;

  UserBloc({@required this.authenticateUser}): assert(authenticateUser != null);


  @override
  UserState get initialState => UserInitial();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async*{
    if (event is AuthenticateUserEvent){
      final failureOrUser = await authenticateUser.authenticate(
        event.password,
      );
      yield failureOrUser.fold( (failure) => Error(message: _mapFailureToMessage(failure))
        ,(user) => Authenticated(),
      );
    }
  }

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
