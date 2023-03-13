import 'dart:convert';

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';
import 'package:meta/meta.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.localDataSource,
  });

  @override
  // ignore: missing_return
  Future<Either<Failure, User>> authenticateUser(String password) async {
    try {
      final users = await localDataSource.getUsers();
      User? _user;

      for (var user in users) {
        if (user.password == password) {
          _user = user;
        }
      }

      if (_user == null) {
        return Left(AuthenticationFailure());
      } else {
        return Right(_user);
      }
    } on CacheException {
      return Left(CacheFailure());
    }
  }

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
