
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/category.dart';
import '../entities/item.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getCategories();

  Future<Either<Failure, List<Item>>> getCategoryItems(int id);
  Future<Either<Failure, List<Item>>> getEanItem(String ean);
}
