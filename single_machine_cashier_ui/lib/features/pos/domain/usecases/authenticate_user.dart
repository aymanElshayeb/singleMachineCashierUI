import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/core/usecases/usecase.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/user.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class AuthenticateUser {
  final UserRepository repository;

  AuthenticateUser(this.repository);

  Future<Either<Failure, User>> authenticate(String password) async {
    return await repository.authenticateUser(password);
  }
}

