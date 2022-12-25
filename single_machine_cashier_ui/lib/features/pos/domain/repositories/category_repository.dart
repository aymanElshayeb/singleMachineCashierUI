import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:dartz/dartz.dart';

import '../entities/category.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getCategories();

}
