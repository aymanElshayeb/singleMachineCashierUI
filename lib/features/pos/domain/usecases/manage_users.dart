import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class ManageUsers {
  final UserRepository repository;

  ManageUsers(this.repository);
  /*Future<Either<Failure, List<User>>> execgetAllUsers() async {
    return await repository.getAllUsers();
  }*/
}
