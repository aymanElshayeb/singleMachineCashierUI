import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/category.dart';
import '../repositories/category_repository.dart';


class Categories {
  final CategoryRepository repository;

  Categories(this.repository);

  // Future<Either<Failure, Category>> getCategory(int id) async {
  //   return await repository.getCategory(id);
  // }

  Future<Either<Failure, List<Category>>> getAllCategories() async{
    return await repository.getCategories();
  }
}

