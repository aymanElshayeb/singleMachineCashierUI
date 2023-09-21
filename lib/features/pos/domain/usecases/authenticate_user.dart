import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class AuthenticateUser {
  final UserRepository repository;

  AuthenticateUser(this.repository);

  Future<Either<Failure, List<User>>> execgetAllUsers() async {
    return await repository.getAllUsers();
  }

  Future<Either<Failure, List<User>>> execAddUser(User user) async {
    return await repository.addUser(user);
  }
}
