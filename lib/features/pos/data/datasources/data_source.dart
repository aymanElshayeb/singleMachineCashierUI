import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';

import '../../domain/entities/category.dart';

abstract class CategoryDataSource {
  Future<Either<Failure, List<Category>>> getCategories();
}