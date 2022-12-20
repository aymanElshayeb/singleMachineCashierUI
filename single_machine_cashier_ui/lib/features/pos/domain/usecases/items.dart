import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/core/usecases/usecase.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/user.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../entities/item.dart';
import '../repositories/item_repository.dart';

class Items implements UseCase<Item,Params>{
  final ItemsRepository repository;

  Items(this.repository);
  Future<Either<Failure, Item>> getItem(Params params) async {
    return await repository.getItem(params.id);
  }


  Future<Either<Failure, Item>> getAllItems(Params params) async {
    return await repository.getAllItems();
  }

  @override
  Future<Either<Failure, Item>> call(Params params) async{
    return await repository.getItem(params.category);
  }
}

class Params extends Equatable{
  final int id;
  final int category;
  Params({this.id,this.category}):super([id,category]);
}