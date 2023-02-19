import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/features/pos/data/models/item_model.dart';
import 'package:single_machine_cashier_ui/features/pos/data/models/user_model.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/item_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/item_local_data_source.dart';
import '../datasources/user_local_data_source.dart';
import 'package:meta/meta.dart';

class ItemRepositoryImpl implements ItemsRepository {
  final ItemLocalDataSource localDataSource;

  ItemRepositoryImpl({
    @required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Item>>> getCategoryItems(int category) async {
    try {
      final items = await localDataSource.getItems();
      List<Item> tempItems;

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
  Future<Either<Failure, Item>> getItem(int id) async {
    try {
      final items = await localDataSource.getItems();
      Item tempItem;

      for (var item in items) {
        if (item.id == id) {
          tempItem = item;
        }
      }

      return Right(tempItem);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
