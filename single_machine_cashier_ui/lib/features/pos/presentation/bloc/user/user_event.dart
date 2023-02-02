import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
@immutable
abstract class UserEvent extends Equatable {
  UserEvent([List props = const <dynamic>[]]) : super(props);
}


class AuthenticateUserEvent extends UserEvent{
  final String password;
  AuthenticateUserEvent(this.password):super([password]);

}