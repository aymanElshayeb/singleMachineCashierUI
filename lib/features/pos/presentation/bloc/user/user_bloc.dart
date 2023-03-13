import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/user/user_event.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/user/user_state.dart';
import 'package:meta/meta.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/authenticate_user.dart';
import 'package:logging/logging.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String AUTHENTICATION_FAILURE_MESSAGE = 'Invalid password';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AuthenticateUser authenticateUser;
  final _log = Logger('UserBloc');

  UserBloc({required this.authenticateUser});

  @override
  UserState get initialState => UserInitial();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is AuthenticateUserEvent) {
      final failureOrUser = await authenticateUser.authenticate(
        event.password,
      );
      yield failureOrUser.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (user) {
          _log.fine(user.fullname);
          return Authenticated(current: user);
        },
      );
    } else if (event is GetAllUsers) {
      final failureOrUsers = await authenticateUser.execgetAllUsers();

      yield failureOrUsers.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (users) => UpdateUsers(our_users: users),
      );
    } else if (event is AddUser) {
      final failureOrUsers = await authenticateUser.execAddUser(event.user);

      yield failureOrUsers.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (users) => UpdateUsers(our_users: users),
      );
    } else if (event is SecondAuthenticate) {
      final failureOrUser = await authenticateUser.authenticate(
        event.password,
      );
      yield failureOrUser.fold(
        (failure) {
          return Error(message: _mapFailureToMessage(failure));
        },
        (user) {
          _log.fine(user.fullname);
          return AuthenticatedAgain(current: user);
        },
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
