import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/category.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource nodeDataSource;
  final CategoryDataSource fireBaseDataSource;
  final CategoryDataSource fireDartDataSource;
  final CategoryDataSource odooDataSource;

  CategoryRepositoryImpl(
      {required this.nodeDataSource,
      required this.fireBaseDataSource,
      required this.fireDartDataSource,
      required this.odooDataSource});
  @override
  Future<Either<Failure, List<Category>>> getCategories() {
    const type = String.fromEnvironment('DATA_SOURCE');
    switch (type) {
      case 'node':
        return nodeDataSource.getCategories();
      case 'firebase':
        return fireBaseDataSource.getCategories();
      case 'firedart':
        return fireDartDataSource.getCategories();
      case 'odoo':
        return odooDataSource.getCategories();
      default:
        throw CacheFailure();
    }
  }
}
