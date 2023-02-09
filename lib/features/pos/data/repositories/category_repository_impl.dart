import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/item_local_data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/items.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/category.dart';

import '../../domain/entities/item.dart';
import '../../domain/repositories/category_repository.dart';

import '../datasources/category_local_data_source.dart';

import 'package:meta/meta.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final ItemLocalDataSource itemLocalDataSource;
  final CategoryLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CategoryRepositoryImpl(
      {@required this.localDataSource,
      @required this.itemLocalDataSource,
      @required this.networkInfo});

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    if (await networkInfo.isConnected) {
    } else {
      try {
        List<Category> categories = await localDataSource.getCategories();

        return Right(categories);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Item>>> getCategoryItems(int category) async {
    if (await networkInfo.isConnected) {
    } else {
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
  }
}
