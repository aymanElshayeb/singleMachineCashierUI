import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/item.dart';
import '../repositories/item_repository.dart';

class Items {
  final ItemsRepository repository;

  Items(this.repository);
  Future<Either<Failure, Item>> getItem(int id) async {
    return await repository.getItem(id);
  }

  Future<Either<Failure, Item>> getItemByCategory(int category) async{
    return await repository.getItem(category);
  }
}

