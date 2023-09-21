import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/user.dart';

typedef EitherUser<T> = Future<Either<String, T>>;

abstract class BaseAuthRepository {
  EitherUser<User> googleSignInUser();
  EitherUser<User> emailSignInUser(String email, String password);
  EitherUser<String> signOutUser();
}
