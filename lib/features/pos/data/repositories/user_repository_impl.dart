import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/features/pos/data/models/user_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';
import 'package:meta/meta.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl(
      {@required this.localDataSource, @required this.networkInfo});

  @override
  // ignore: missing_return
  Future<Either<Failure, User>> authenticateUser(String password) async {
    if (await networkInfo.isConnected) {
    } else {
      try {
        final users = await localDataSource.getUsers();
        UserModel _user;

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
  }

  @override
  Future<Either<Failure, List<User>>> getAllUsers() async {
    if (await networkInfo.isConnected) {
    } else {
      try {
        List<User> users = await localDataSource.getUsers();
        return Right(users);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<User>>> addUser(User user) async {
    if (await networkInfo.isConnected) {
    } else {
      try {
        List<User> users = await localDataSource.addUsers(UserModel(
            userName: user.userName,
            id: user.id,
            fullname: user.fullname,
            role: user.role,
            password: user.password));
        return Right(users);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
