import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/item_local_data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/items.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/category.dart';

import '../../domain/entities/item.dart';
import '../../domain/repositories/category_repository.dart';

import '../datasources/category_local_data_source.dart';

import 'package:meta/meta.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final ItemLocalDataSource itemLocalDataSource;
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl({
    @required this.localDataSource,
    @required this.itemLocalDataSource,
  });

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      List<Category> categories = await localDataSource.getCategories();

      return Right(categories);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Item>>> getCategoryItems(int category) async {
    try {
      final items = await itemLocalDataSource.getItems();
      List<Item> tempItems = [];

      for (var item in items) {
        if (item.category == category) {
          tempItems.add(item);
        }
      }

      return Right(tempItems);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Item>>> getEanItem(String ean) async {
    try {
      final items = await itemLocalDataSource.getItems();
      List<Item> tempItems = [];

      for (var item in items) {
        if (item.PLU_EAN.contains(ean)) {
          tempItems.add(item);
          print(item.PLU_EAN + ', ' + item.name);
        }
      }

      return Right(tempItems);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

}
