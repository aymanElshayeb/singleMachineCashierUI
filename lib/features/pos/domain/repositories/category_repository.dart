import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/items.dart';

import '../entities/category.dart';
import '../entities/item.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getCategories();

  Future<Either<Failure, List<Item>>> getCategoryItems(int id);
  Future<Either<Failure, List<Item>>> getEanItem(String ean);
}
