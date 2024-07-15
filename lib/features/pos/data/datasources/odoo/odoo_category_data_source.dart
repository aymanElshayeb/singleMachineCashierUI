import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/category.dart';

class OdooCategoryDataSource implements CategoryDataSource {
  @override
  Future<Either<Failure, List<Category>>> getCategories() {
    // TODO: implement getCategories
    throw UnimplementedError();
  }

}