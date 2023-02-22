import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> authenticateUser(String password);
  Future<Either<Failure, List<User>>> getAllUsers();
  Future<Either<Failure, List<User>>> addUser(User user);
}
