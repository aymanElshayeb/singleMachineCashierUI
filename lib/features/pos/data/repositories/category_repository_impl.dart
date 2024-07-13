import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/category.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource localDataSource;
  final CategoryDataSource cloudDataSource;
  final CategoryDataSource odooDataSource;

  CategoryRepositoryImpl(
      {required this.localDataSource,
      required this.cloudDataSource,
      required this.odooDataSource});
  @override
  Future<Either<Failure, List<Category>>> getCategories() {
    const type = String.fromEnvironment('DATA_SOURCE');
    switch (type) {
      case 'local':
        return localDataSource.getCategories();
      case 'cloud':
        return cloudDataSource.getCategories();
      case 'odoo':
        return odooDataSource.getCategories();
      default:
        throw CacheFailure();
    }
  }
}
