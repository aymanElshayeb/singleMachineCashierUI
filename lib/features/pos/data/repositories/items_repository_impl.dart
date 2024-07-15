import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/item_repository.dart';

class ItemsRepositoryImpl implements ItemsRepository {
  final ItemsDataSource nodeDataSource;
  final ItemsDataSource fireBaseDataSource;
  final ItemsDataSource fireDartDataSource;
  final ItemsDataSource odooDataSource;

  ItemsRepositoryImpl({required this.nodeDataSource, required this.fireBaseDataSource, required this.fireDartDataSource, required this.odooDataSource});
  @override
  Future<Either<Failure, List<Item>>> getCategoryItems({String? categoryId}) {
    const type = String.fromEnvironment('DATA_SOURCE');
    switch (type) {
      case 'node':
        return nodeDataSource.getCategoryItems(categoryId: categoryId);
      case 'firebase':
        return fireBaseDataSource.getCategoryItems(categoryId: categoryId);
      case 'firedart':
        return fireDartDataSource.getCategoryItems(categoryId: categoryId);
      case 'odoo':
        return odooDataSource.getCategoryItems(categoryId: categoryId);
      default:
        throw CacheFailure();
    }
  }

  @override
  Future<Either<Failure, List<Item>>> getItemsByEan({required String keyWord}) {
    const type = String.fromEnvironment('DATA_SOURCE');
    switch (type) {
      case 'node':
        return nodeDataSource.getItemsByEan(keyWord: keyWord);
      case 'firebase':
        return fireBaseDataSource.getItemsByEan(keyWord: keyWord);
      case 'firedart':
        return fireDartDataSource.getItemsByEan(keyWord: keyWord);
      case 'odoo':
        return odooDataSource.getItemsByEan(keyWord: keyWord);
      default:
        throw CacheFailure();
    }
  }

}