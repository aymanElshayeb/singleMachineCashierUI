
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/item.dart';
import '../repositories/item_repository.dart';

class Items {
  final ItemsRepository repository;

  Items(this.repository);
  Future<Either<Failure, Item>> getItem(int id) async {
    return await repository.getItem(id);
  }

  Future<Either<Failure, List<Item>>> getItemsByCategory(int category) async {
    return await repository.getCategoryItems(category);
  }
}
