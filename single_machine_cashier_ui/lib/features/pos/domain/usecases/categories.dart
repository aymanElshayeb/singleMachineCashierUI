import 'package:flutter/foundation.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../repositories/category_repository.dart';


class Categories implements UseCase<Category,Params>{
  final CategoryRepository repository;

  Categories(this.repository);

  Future<Either<Failure, Category>> getCategory(Params params) async {
    return await repository.getCategory(params.id);
  }

  @override
  Future<Either<Failure, Category>> call(Params params) async{
    return await repository.getCategories();
  }
}

class Params extends Equatable{
  final int id;

  Params({this.id}):super([id]);
}