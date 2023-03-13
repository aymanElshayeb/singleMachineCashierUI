import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../entities/category.dart';
import '../entities/item.dart';
import '../repositories/category_repository.dart';
import 'items.dart';

class Categories {
  final CategoryRepository repository;

  Categories(this.repository);
  Future<Either<Failure, List<Category>>> getAllCategories() async {
    return await repository.getCategories();
  }

  Future<Either<Failure, List<Item>>> getCategoryItems(int id) async {
    return await repository.getCategoryItems(id);
  }

  Future<Either<Failure, List<Item>>> execGetEanItem(String ean) async {
    return await repository.getEanItem(ean);
  }
}
