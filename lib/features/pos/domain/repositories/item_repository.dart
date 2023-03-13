
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/item.dart';

abstract class ItemsRepository {
  Future<Either<Failure, List<Item>>> getCategoryItems(int category);
  Future<Either<Failure, Item>> getItem(int id);

}
