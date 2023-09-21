import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.localDataSource,
  });

  @override
  // ignore: missing_return

  @override
  Future<Either<Failure, List<User>>> getAllUsers() async {
    try {
      List<User> users = await localDataSource.getUsers();
      return Right(users);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<User>>> addUser(User user) async {
    try {
      List<User> users = await localDataSource.addUsers(user);
      return Right(users);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
