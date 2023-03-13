
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';


abstract class UserRepository {
  Future<Either<Failure, User>> authenticateUser(String password);
  Future<Either<Failure, List<User>>> getAllUsers();
  Future<Either<Failure, List<User>>> addUser(User user);
}
